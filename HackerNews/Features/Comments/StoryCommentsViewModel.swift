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
        guard !didFetchInitialData else { return }
        didFetchInitialData = true
        
        isLoading = true
        defer { isLoading = false }
        
        let ids = story.kids ?? []
        let items = await client.getItems(ids: ids)
        
        comments = items.map { makeComment(from: $0, level: 0) }
    }
    
    func getComments(for id: Int) async {
        guard let index = findCommentIndex(by: id) else { return }
        let parent = comments[index]
        
        comments[index].state = .onLoading
        
        let ids = parent.comment.kids ?? []
        let items = await client.getItems(ids: ids)
        let mapped = items.map { makeComment(from: $0, level: parent.level + 1) }
        
        if mapped.isEmpty {
            comments[index].state = .noReplies
            return
        }
        
        comments.insert(contentsOf: mapped, at: index + 1)
        comments[index].state = .replies
    }
    
    private func findCommentIndex(by id: Int) -> Int? {
        comments.firstIndex(where: { $0.id == id })
    }
    
    private func makeComment(from item: DomainItem, level: Int) -> Comment {
        let hasReplies = (item.kids?.isEmpty == false)
        let state: Comment.CommentState = hasReplies ? .withButton : .noReplies
        
        return Comment(
            comment: item,
            attributedText: AttributedString(html: item.text ?? "") ?? AttributedString(""),
            state: state,
            level: level
        )
    }
}

