//
//  StoriesViewModel.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 19/11/25.
//

import SwiftUI
import HackerNewsClient
import Paginator

@MainActor @Observable
class StoriesViewModel {
    
    var selectedCategory: StoriesCategory = .top
    
    @ObservationIgnored
    private var didFetchInitialData = false
    
    private let client: HackerNewsClientProtocol
    var paginator: Paginator<StoriesPaginatorClient>
    
    init(client: HackerNewsClientProtocol) {
        self.client = client
        paginator = Paginator(paginatorClient: .init(client: client, selectedCategory: .top))
    }
    
    func fetchInitialData() async {
        if didFetchInitialData { return }
        didFetchInitialData = true
        paginator.client.selectedCategory = selectedCategory
        await paginator.fetchData()
    }
    
    func fetchData() async {
        await paginator.fetchData()
    }
    
    func fetchNextBatchIfNeeded(currentItemId: Int) async {
        await paginator.fetchNextBatchIfNeeded(currentItemId: currentItemId)
    }
}
