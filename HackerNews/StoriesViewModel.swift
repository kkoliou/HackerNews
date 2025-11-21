//
//  StoriesViewModel.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 19/11/25.
//

import SwiftUI
import HackerNewsClient

@MainActor @Observable
class StoriesViewModel {
    
    @ObservationIgnored
    private let pageSize = 30
    
    @ObservationIgnored
    private var selectedCategoryStoryIds = [Int]()
    
    var stories = [DomainItem]()
    var isLoading = false
    var selectedCategory: StoriesCategory = .top
    var isPagingLoading = false
    
    private let client: HackerNewsClientProtocol
    
    init(client: HackerNewsClientProtocol) {
        self.client = client
    }
    
    func fetchData() async {
        isLoading = true
        let ids = try? await fetchStoryIds(for: selectedCategory)
        selectedCategoryStoryIds = ids ?? []
        let stories = await client.getItems(ids: Array(selectedCategoryStoryIds.prefix(pageSize)))
        isLoading = false
        self.stories = stories
    }
    
    func fetchNextBatchIfNeeded(currentItemId: Int) async {
        guard !isPagingLoading, currentItemId == stories.last?.id
        else { return }
        await fetchNextBatch()
    }
    
    private func fetchNextBatch() async {
        isPagingLoading = true
        
        let startIndex = stories.count
        let endIndex = min(startIndex + pageSize, selectedCategoryStoryIds.count)
        let nextBatchIds = Array(selectedCategoryStoryIds[startIndex..<endIndex])
        
        let stories = await client.getItems(ids: nextBatchIds)
        
        isPagingLoading = false
        
        self.stories.append(contentsOf: stories)
    }

    private func fetchStoryIds(for category: StoriesCategory) async throws -> [Int] {
        switch category {
        case .top:
            return try await client.getTopStories()
        case .new:
            return try await client.getNewStories()
        case .best:
            return try await client.getBestStories()
        case .ask:
            return try await client.getAskStories()
        case .show:
            return try await client.getShowStories()
        case .job:
            return try await client.getJobStories()
        }
    }
}
