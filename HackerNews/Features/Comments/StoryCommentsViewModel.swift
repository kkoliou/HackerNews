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
        self.comments = await client.getItems(ids: story.kids ?? [])
            .map({
            let state: Comment.CommentState
            if ($0.kids?.count ?? 0) > 0 {
                state = .withButton
            } else {
                state = .noReplies
            }
            return Comment(
                comment: $0,
                attributedText: .init(html: $0.text ?? "") ?? AttributedString(""),
                state: state,
                level: 0
            )
        })
        isLoading = false
    }
    
    func getComments(for id: Int) async {
        guard let targetIndex = findCommentIndex(by: id) else { return }
        let target = comments[targetIndex]
        
        target.state = .onLoading

        let items = await client.getItems(ids: target.comment.kids ?? [])
            .map({
                let hasReplies = $0.kids?.isEmpty == false
                return Comment(
                    comment: $0,
                    attributedText: .init(html: $0.text ?? "") ?? AttributedString(""),
                    state: hasReplies ? .withButton : .noReplies,
                    level: target.level + 1
                )
            })
        
        if !items.isEmpty {
            comments.insert(contentsOf: items, at: targetIndex + 1)
            target.state = .replies
        } else {
            target.state = .noReplies
        }
    }
    
    func findCommentIndex(by id: Int) -> Int? {
        comments.firstIndex(where: { $0.id == id })
    }
}
