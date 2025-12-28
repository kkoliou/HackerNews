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
    
    @ObservationIgnored
    private let pageSize = 30
    
    @ObservationIgnored
    private var subcommentsFetched = 0
    
    var kidsIds = [Int]()
    var comments = [Comment]()
    var isLoading = false
    var isPagingLoading = false
    
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
        
        kidsIds = story.kids ?? []
        let items = await client.getItems(ids: Array(kidsIds.prefix(pageSize)))
        
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
        
        subcommentsFetched += mapped.count
    }
    
    func fetchNextBatchIfNeeded(currentItemId: Int) async {
        guard !isPagingLoading, currentItemId == comments.last?.id
        else { return }
        await fetchNextBatch()
    }
    
    private func fetchNextBatch() async {
        isPagingLoading = true
        
        let startIndex = comments.count - subcommentsFetched
        let endIndex = min(startIndex + pageSize, kidsIds.count)
        let nextBatchIds = Array(kidsIds[startIndex..<endIndex])
        
        let comments = await client.getItems(ids: nextBatchIds)
            .map { makeComment(from: $0, level: 0) }
        
        isPagingLoading = false
        
        self.comments.append(contentsOf: comments)
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

