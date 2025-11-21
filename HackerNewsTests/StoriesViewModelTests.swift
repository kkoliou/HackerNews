//
//  StoriesViewModelTests.swift
//  HackerNewsTests
//
//  Created by Konstantinos Kolioulis on 21/11/25.
//

import Foundation
import Testing
import HackerNewsClient
@testable import HackerNews

@MainActor
struct StoriesViewModelTests {
    
    // MARK: - Initial State Tests
    
    @Test("Initial state has correct default values")
    func initialState() async {
        let mockClient = MockHackerNewsClient()
        let sut = StoriesViewModel(client: mockClient)
        
        #expect(sut.stories.isEmpty)
        #expect(!sut.isLoading)
        #expect(!sut.isPagingLoading)
        #expect(sut.selectedCategory == .top)
    }
    
    // MARK: - fetchData Tests
    
    @Test("fetchData loads correct number of stories on success")
    func fetchDataSuccess() async {
        // Given
        let mockClient = MockHackerNewsClient()
        let mockIds = Array(1...50)
        let mockStories = mockIds.prefix(30).map { createMockStory(id: $0) }
        
        mockClient.topStoriesResult = .success(mockIds)
        mockClient.itemsToReturn = mockStories
        
        let sut = StoriesViewModel(client: mockClient)
        
        // When
        await sut.fetchData()
        
        // Then
        #expect(sut.stories.count == 30)
        #expect(sut.stories.first?.id == 1)
        #expect(sut.stories.last?.id == 30)
        #expect(!sut.isLoading)
        #expect(mockClient.getItemsCallCount == 1)
    }
    
    @Test("fetchData manages loading state correctly")
    func fetchDataLoadingState() async {
        // Given
        let mockClient = MockHackerNewsClient()
        mockClient.topStoriesResult = .success([1, 2, 3])
        mockClient.itemsToReturn = [createMockStory(id: 1)]
        mockClient.delayDuration = 0.1
        
        let sut = StoriesViewModel(client: mockClient)
        
        // When
        let fetchTask = Task {
            await sut.fetchData()
        }
        
        // Then - Check loading state during fetch
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        #expect(sut.isLoading)
        
        await fetchTask.value
        #expect(!sut.isLoading)
    }
    
    @Test("fetchData handles empty response")
    func fetchDataEmptyResponse() async {
        // Given
        let mockClient = MockHackerNewsClient()
        mockClient.topStoriesResult = .success([])
        mockClient.itemsToReturn = []
        
        let sut = StoriesViewModel(client: mockClient)
        
        // When
        await sut.fetchData()
        
        // Then
        #expect(sut.stories.isEmpty)
        #expect(!sut.isLoading)
    }
    
    @Test("fetchData handles error gracefully")
    func fetchDataHandlesError() async {
        // Given
        let mockClient = MockHackerNewsClient()
        mockClient.topStoriesResult = .failure(NSError(domain: "test", code: -1))
        
        let sut = StoriesViewModel(client: mockClient)
        
        // When
        await sut.fetchData()
        
        // Then
        #expect(sut.stories.isEmpty)
        #expect(!sut.isLoading)
    }
    
    // MARK: - Category Tests
    
    @Test("fetchData uses correct endpoint for each category",
          arguments: [
            (StoriesCategory.top, \MockHackerNewsClient.getTopStoriesCallCount),
            (.new, \MockHackerNewsClient.getNewStoriesCallCount),
            (.best, \MockHackerNewsClient.getBestStoriesCallCount),
            (.ask, \MockHackerNewsClient.getAskStoriesCallCount),
            (.show, \MockHackerNewsClient.getShowStoriesCallCount),
            (.job, \MockHackerNewsClient.getJobStoriesCallCount)
          ])
    func fetchDataForCategory(
        category: StoriesCategory,
        callCountKeyPath: KeyPath<MockHackerNewsClient, Int>
    ) async {
        // Given
        let mockClient = MockHackerNewsClient()
        let mockIds = [1, 2, 3]
        let mockStories = mockIds.map { createMockStory(id: $0) }
        
        mockClient.topStoriesResult = .success(mockIds)
        mockClient.newStoriesResult = .success(mockIds)
        mockClient.bestStoriesResult = .success(mockIds)
        mockClient.askStoriesResult = .success(mockIds)
        mockClient.showStoriesResult = .success(mockIds)
        mockClient.jobStoriesResult = .success(mockIds)
        mockClient.itemsToReturn = mockStories
        
        let sut = StoriesViewModel(client: mockClient)
        sut.selectedCategory = category
        
        // When
        await sut.fetchData()
        
        // Then
        #expect(mockClient[keyPath: callCountKeyPath] == 1)
        #expect(sut.stories.count == 3)
    }
    
    // MARK: - Pagination Tests
    
    @Test("fetchNextBatchIfNeeded does not trigger when not last item")
    func fetchNextBatchNotLastItem() async {
        // Given
        let (sut, _) = await setupStoriesForPagination()
        let initialCount = sut.stories.count
        
        // When - trigger with an item that's not the last one
        await sut.fetchNextBatchIfNeeded(currentItemId: 15)
        
        // Then
        #expect(sut.stories.count == initialCount)
        #expect(!sut.isPagingLoading)
    }
    
    @Test("fetchNextBatchIfNeeded triggers on last item")
    func fetchNextBatchOnLastItem() async {
        // Given
        let (sut, _) = await setupStoriesForPagination()
        let initialCount = sut.stories.count
        
        // When - trigger with the last item
        guard let lastItemId = sut.stories.last?.id else {
            Issue.record("No stories found")
            return
        }
        await sut.fetchNextBatchIfNeeded(currentItemId: lastItemId)
        
        // Then
        #expect(sut.stories.count == initialCount + 30)
        #expect(!sut.isPagingLoading)
    }
    
    @Test("fetchNextBatchIfNeeded does not trigger when already paging")
    func fetchNextBatchPreventsDuplicates() async {
        // Given
        let (sut, mockClient) = await setupStoriesForPagination()
        mockClient.delayDuration = 0.2
        
        // When - trigger pagination twice quickly
        guard let lastItemId = sut.stories.last?.id else {
            Issue.record("No stories found")
            return
        }
        let task1 = Task {
            await sut.fetchNextBatchIfNeeded(currentItemId: lastItemId)
        }
        
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        await sut.fetchNextBatchIfNeeded(currentItemId: lastItemId)
        
        await task1.value
        
        // Then - should only fetch once
        #expect(mockClient.getItemsCallCount == 2) // 1 for initial + 1 for pagination
    }
    
    @Test("fetchNextBatch handles end of list correctly")
    func fetchNextBatchEndOfList() async {
        // Given - Set up with exactly 40 items (will load 30 initially, 10 remaining)
        let mockClient = MockHackerNewsClient()
        let mockIds = Array(1...40)
        mockClient.topStoriesResult = .success(mockIds)
        mockClient.itemsToReturn = mockIds.prefix(30).map { createMockStory(id: $0) }
        
        let sut = StoriesViewModel(client: mockClient)
        await sut.fetchData()
        
        // Set up next batch
        mockClient.itemsToReturn = mockIds.suffix(10).map { createMockStory(id: $0) }
        
        // When - fetch next batch
        guard let lastItemId = sut.stories.last?.id else {
            Issue.record("No stories found")
            return
        }
        await sut.fetchNextBatchIfNeeded(currentItemId: lastItemId)
        
        // Then
        #expect(sut.stories.count == 40)
        
        // Try to fetch again (should not trigger since we're at the end)
        guard let newLastItemId = sut.stories.last?.id else {
            Issue.record("No stories found after pagination")
            return
        }
        let countBefore = sut.stories.count
        await sut.fetchNextBatchIfNeeded(currentItemId: newLastItemId)
        #expect(sut.stories.count == countBefore)
    }
    
    @Test("Pagination sets isPagingLoading during fetch")
    func paginationLoadingState() async {
        // Given
        let (sut, mockClient) = await setupStoriesForPagination()
        mockClient.delayDuration = 0.1
        
        // When
        guard let lastItemId = sut.stories.last?.id else {
            Issue.record("No stories found")
            return
        }
        let paginationTask = Task {
            await sut.fetchNextBatchIfNeeded(currentItemId: lastItemId)
        }
        
        // Then - Check paging loading state during fetch
        try? await Task.sleep(nanoseconds: 10_000_000) // 0.01 seconds
        #expect(sut.isPagingLoading)
        
        await paginationTask.value
        #expect(!sut.isPagingLoading)
    }
    
    private func setupStoriesForPagination() async -> (StoriesViewModel, MockHackerNewsClient) {
        let mockClient = MockHackerNewsClient()
        let mockIds = Array(1...100)
        mockClient.topStoriesResult = .success(mockIds)
        mockClient.itemsToReturn = mockIds.prefix(30).map { createMockStory(id: $0) }
        
        let sut = StoriesViewModel(client: mockClient)
        await sut.fetchData()
        
        // Set up items for next batch
        mockClient.itemsToReturn = mockIds.dropFirst(30).prefix(30).map { createMockStory(id: $0) }
        
        return (sut, mockClient)
    }
    
    private func createMockStory(id: Int) -> DomainStory {
        DomainStory(
            id: id,
            title: "Story \(id)",
            author: "user\(id)",
            url: URL(string: "https://example.com/\(id)"),
            type: "story",
            score: 100,
            descendants: 10,
            kids: nil,
            time: Date()
        )
    }
}

// MARK: - Mock Client

final class MockHackerNewsClient: HackerNewsClientProtocol, @unchecked Sendable {
    
    var topStoriesResult: Result<[Int], Error> = .success([])
    var newStoriesResult: Result<[Int], Error> = .success([])
    var bestStoriesResult: Result<[Int], Error> = .success([])
    var jobStoriesResult: Result<[Int], Error> = .success([])
    var askStoriesResult: Result<[Int], Error> = .success([])
    var showStoriesResult: Result<[Int], Error> = .success([])
    var itemsToReturn: [DomainStory] = []
    var delayDuration: TimeInterval = 0
    
    var getTopStoriesCallCount = 0
    var getNewStoriesCallCount = 0
    var getBestStoriesCallCount = 0
    var getJobStoriesCallCount = 0
    var getAskStoriesCallCount = 0
    var getShowStoriesCallCount = 0
    var getItemsCallCount = 0
    
    func getTopStories() async throws -> [Int] {
        getTopStoriesCallCount += 1
        try await delay()
        return try topStoriesResult.get()
    }
    
    func getNewStories() async throws -> [Int] {
        getNewStoriesCallCount += 1
        try await delay()
        return try newStoriesResult.get()
    }
    
    func getBestStories() async throws -> [Int] {
        getBestStoriesCallCount += 1
        try await delay()
        return try bestStoriesResult.get()
    }
    
    func getJobStories() async throws -> [Int] {
        getJobStoriesCallCount += 1
        try await delay()
        return try jobStoriesResult.get()
    }
    
    func getAskStories() async throws -> [Int] {
        getAskStoriesCallCount += 1
        try await delay()
        return try askStoriesResult.get()
    }
    
    func getShowStories() async throws -> [Int] {
        getShowStoriesCallCount += 1
        try await delay()
        return try showStoriesResult.get()
    }
    
    func getItem(id: Int) async throws -> DomainStory {
        try await delay()
        return itemsToReturn.first { $0.id == id } ?? createDefaultStory(id: id)
    }
    
    func getItems(ids: [Int]) async -> [DomainStory] {
        getItemsCallCount += 1
        try? await delay()
        return itemsToReturn.filter { ids.contains($0.id!) }
    }
    
    private func delay() async throws {
        if delayDuration > 0 {
            try await Task.sleep(nanoseconds: UInt64(delayDuration * 1_000_000_000))
        }
    }
    
    private func createDefaultStory(id: Int) -> DomainStory {
        DomainStory(
            id: id,
            title: "Default Story",
            author: "user",
            url: nil,
            type: "story",
            score: 0,
            descendants: 0,
            kids: nil,
            time: Date()
        )
    }
}
