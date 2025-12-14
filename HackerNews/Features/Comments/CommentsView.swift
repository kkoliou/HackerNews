//
//  CommentsView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 22/11/25.
//

import SwiftUI
import HackerNewsClient

struct CommentsView: View {
    
    @Environment(\.openURL) var openURL
    @Environment(\.navigate) private var navigate
    @State var viewModel: StoryCommentsViewModel
    
    init(viewModel: StoryCommentsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 32) {
                        CommentsStoryView(
                            story: viewModel.story
                        )
                        
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.comments, id: \.id) {
                                CommentRowView(viewModel: viewModel, comment: $0)
                            }
                        }
                        
                        if viewModel.isPagingLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .id(viewModel.comments.count) // used to rerender that loader
                        }
                    }
                    .padding(16)
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(
                    action: {
                        guard let url = viewModel.story.url else { return }
                        openURL.open(url)
                    },
                    label: {
                        Image(systemName: "link")
                    }
                )
            }
        })
        .task {
            await viewModel.getInitialComments()
        }
    }
}
