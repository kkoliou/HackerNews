//
//  Comment.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 1/12/25.
//

import SwiftUI
import HackerNewsClient

@Observable
class Comment {
    enum CommentState {
        case withButton
        case onLoading
        case noReplies
        case replies
    }
    
    var id: Int { comment.id ?? 0 }
    let comment: DomainItem
    let attributedText: AttributedString
    var state: CommentState
    let level: Int
    
    init(
        comment: DomainItem,
        attributedText: AttributedString,
        state: CommentState,
        level: Int
    ) {
        self.comment = comment
        self.attributedText = attributedText
        self.state = state
        self.level = level
    }
}
