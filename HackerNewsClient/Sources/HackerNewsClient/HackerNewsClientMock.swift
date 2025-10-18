//
//  HackerNewsClientMock.swift
//  HackerNewsClient
//
//  Created by Konstantinos Kolioulis on 18/10/25.
//

import Foundation

public actor StoriesStorage {
    public var stories: [DomainStory]
    public init(stories: [DomainStory]) {
        self.stories = stories
    }
}

final public class HackerNewsClientMock: HackerNewsClientProtocol {
    
    public let storage: StoriesStorage
    public let topStories: [Int]
    
    public init(storage: StoriesStorage, topStories: [Int]) {
        self.storage = storage
        self.topStories = topStories
    }
    
    public func getTopStories() async throws -> [Int] {
        return topStories
    }
    
    public func getNewStories() async throws -> [Int] {
        return []
    }
    
    public func getBestStories() async throws -> [Int] {
        return []
    }
    
    public func getJobStories() async throws -> [Int] {
        return []
    }
    
    public func getAskStories() async throws -> [Int] {
        return []
    }
    
    public func getShowStories() async throws -> [Int] {
        return []
    }
    
    public func getItem(id: Int) async throws -> DomainStory {
        if let story = await storage.stories.first(where: { $0.id == id }) {
            return story
        } else {
            throw StoryError()
        }
    }
    
    public func getItems(ids: [Int]) async -> [DomainStory] {
        var storiesToReturn = [DomainStory]()
        for id in ids {
            if let story = await storage.stories.first(where: { $0.id == id }) {
                storiesToReturn.append(story)
            }
        }
        return storiesToReturn
    }
}
