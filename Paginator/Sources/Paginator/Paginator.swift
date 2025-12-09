//
//  Paginator.swift
//  Paginator
//
//  Created by Konstantinos Kolioulis on 8/12/25.
//

import Foundation
import SwiftUI

@MainActor @Observable
public class Paginator<Client: PaginatorClient> {
    
    public var isLoading = false
    public var isPagingLoading = false
    public var allIds = [Client.ItemId]()
    public let pageSize: Int
    public var items = [Client.Item]()
    public var client: Client
    
    public init(
        isPagingLoading: Bool = false,
        pageSize: Int = 30,
        paginatorClient: Client
    ) {
        self.isPagingLoading = isPagingLoading
        self.pageSize = pageSize
        self.client = paginatorClient
        self.allIds = allIds
    }
    
    public func fetchData() async {
        isLoading = true
        let ids = try? await client.getIds()
        allIds = ids ?? []
        let items = await client.getItems(ids: Array(allIds.prefix(pageSize)))
        isLoading = false
        self.items = items
    }
    
    public func fetchNextBatchIfNeeded(currentItemId: Client.ItemId) async {
        guard !isPagingLoading, currentItemId == items.last?.itemId
        else { return }
        await fetchNextBatch()
    }
    
    private func fetchNextBatch() async {
        isPagingLoading = true
        
        let startIndex = items.count
        let endIndex = min(startIndex + pageSize, allIds.count)
        let nextBatchIds = Array(allIds[startIndex..<endIndex])
        
        let items = await client.getItems(ids: nextBatchIds)
        
        isPagingLoading = false
        
        self.items.append(contentsOf: items)
    }
    
}

@MainActor
public protocol IdentifiableItem {
    associatedtype ItemId: Equatable
    var itemId: ItemId? { get }
}

@MainActor
public protocol PaginatorClient {
    associatedtype Item: IdentifiableItem
    typealias ItemId = Item.ItemId
    
    func getIds() async throws -> [ItemId]
    func getItems(ids: [ItemId]) async -> [Item]
}
