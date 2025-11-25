//
//  StoryCommentsView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 22/11/25.
//

import SwiftUI
import HackerNewsClient

struct StoryCommentsView: View {
    
    let viewModel: StoryCommentsViewModel
    
    init(viewModel: StoryCommentsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.comments) {
                            CommentView(comment: $0)
                        }
                    }
                }
//                }
                
            }
        }
        .navigationTitle(viewModel.story.title ?? "")
        .task {
            await viewModel.getInitialComments()
        }
    }
}

struct CommentView: View {
    let comment: Comment
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.attributedText)
                Spacer()
            }
            
            ForEach(comment.comments) { child in
                CommentView(comment: child)
                    .padding(.leading, 16)
            }
        }
    }
}

@MainActor @Observable
class StoryCommentsViewModel {
    
    var comments = [Comment]()
    var isLoading = false
    
    private let client: HackerNewsClientProtocol
    let story: DomainItem
    
    init(
        client: HackerNewsClientProtocol,
        story: DomainItem
    ) {
        self.client = client
        self.story = story
    }
    
    func getInitialComments() async {
        isLoading = true
        let comments = await client.getItems(ids: story.kids ?? [])
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

struct Comment: Identifiable {
    var id: Int { comment.id ?? 0 }
    let comment: DomainItem
    let comments: [Comment]
    let attributedText: AttributedString
}
