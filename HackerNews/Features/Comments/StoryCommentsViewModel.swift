//
//  StoryCommentsViewModel.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 26/11/25.
//

import SwiftUI
import HackerNewsClient

@MainActor @Observable
class StoryCommentsViewModel {
    
    var comments = [Comment]()
    var isLoading = false
    
    private let client: HackerNewsClientProtocol
    let story: DomainItem
    
    @ObservationIgnored
    private var didFetchInitialData = false
    
    init(
        client: HackerNewsClientProtocol,
        story: DomainItem
    ) {
        self.client = client
        self.story = story
    }
    
    func getInitialComments() async {
        if didFetchInitialData { return }
        didFetchInitialData = true
        isLoading = true
        let comments = await client.getItems(ids: story.kids ?? [])
            .filter({ !($0.text ?? "").isEmpty })
        self.comments = comments.map({
            Comment(
                comment: $0,
                comments: [],
                attributedText: .init(html: $0.text ?? "") ?? AttributedString("")
            )
        })
        isLoading = false
    }
    
    func getComments(ids: [Int]) async -> [DomainItem] {
        []
    }
}
