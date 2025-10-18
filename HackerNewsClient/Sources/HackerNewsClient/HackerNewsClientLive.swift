//
//  File.swift
//  HackerNewsClient
//
//  Created by Konstantinos Kolioulis on 17/10/25.
//

import Foundation

final public class HackerNewsClientLive: HackerNewsClientProtocol {
    
    private let baseUrl = "https://hacker-news.firebaseio.com/v0"
    
    public init() {}

    public func getTopStories() async throws -> [Int] {
        try await fetchStoryIds(endpoint: "topstories.json")
    }

    public func getNewStories() async throws -> [Int] {
        try await fetchStoryIds(endpoint: "newstories.json")
    }

    public func getBestStories() async throws -> [Int] {
        try await fetchStoryIds(endpoint: "beststories.json")
    }

    public func getJobStories() async throws -> [Int] {
        try await fetchStoryIds(endpoint: "jobstories.json")
    }

    public func getAskStories() async throws -> [Int] {
        try await fetchStoryIds(endpoint: "askstories.json")
    }

    public func getShowStories() async throws -> [Int] {
        try await fetchStoryIds(endpoint: "showstories.json")
    }

    public func getItem(id: Int) async throws -> DomainStory {
        guard let url = URL(string: "\(baseUrl)/item/\(id).json") else {
            throw StoryError()
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let apiStory = try JSONDecoder().decode(StoryResponse.self, from: data)
        return apiStory.toDomain()
    }
    
    public func getItems(ids: [Int]) async -> [DomainStory] {
        let indexById: [Int: Int] = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($1, $0) })
        
        let stories = await withTaskGroup(
            of: DomainStory?.self
        ) { group in
            for id in ids {
                group.addTask { [weak self] in
                    guard let self else { return  nil }
                    return try? await getItem(id: id)
                }
            }
            
            var stories = [DomainStory]()
            for await story in group {
                guard let story else { continue }
                stories.append(story)
            }
            
            return stories
        }
        
        let sorted = stories.sorted { lhs, rhs in
            guard let lhsId = lhs.id, let rhsId = rhs.id else { return false }
            let lIndex = indexById[lhsId] ?? 0
            let rIndex = indexById[rhsId] ?? 1
            return lIndex < rIndex
        }
        
        return sorted
    }
    
    private func fetchStoryIds(endpoint: String) async throws -> [Int] {
        guard let url = URL(string: "\(baseUrl)/\(endpoint)") else {
            throw StoryError()
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decodeAsIds(data)
    }

    private func decodeAsIds(_ data: Data) throws -> [Int] {
        try JSONDecoder().decode([Int].self, from: data)
    }
}

public struct StoryError: Error {}
