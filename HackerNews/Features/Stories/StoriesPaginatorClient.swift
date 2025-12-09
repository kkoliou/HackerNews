//
//  StoriesPaginatorClient.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 9/12/25.
//

import Paginator
import HackerNewsClient

struct StoriesPaginatorClient: PaginatorClient {
    
    private let client: HackerNewsClientProtocol
    var selectedCategory: StoriesCategory
    
    init(
        client: HackerNewsClientProtocol,
        selectedCategory: StoriesCategory
    ) {
        self.client = client
        self.selectedCategory = selectedCategory
    }
    
    func getIds() async throws -> [Int] {
        switch selectedCategory {
        case .top: return try await client.getTopStories()
        case .new: return try await client.getNewStories()
        case .best: return try await client.getBestStories()
        case .ask: return try await client.getAskStories()
        case .show: return try await client.getShowStories()
        case .job: return try await client.getJobStories()
        }
    }
    
    func getItems(ids: [Int]) async -> [DomainItem] {
        return await client.getItems(ids: ids)
    }
}

extension DomainItem: @retroactive IdentifiableItem {
    public var itemId: Int? {
        id
    }
}
