//
//  CommentRowView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 26/11/25.
//

import SwiftUI
import HackerNewsClient

struct CommentRowView: View {
    
    @Bindable var viewModel: StoryCommentsViewModel
    let comment: Comment
    private var basePadding: CGFloat { CGFloat(comment.level * 16) }
    private var repliesPadding: CGFloat { CGFloat((comment.level + 1) * 16) }
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            HStack {
                Text(comment.attributedText)
                Spacer()
            }
            .padding(.leading, basePadding)
            
            switch comment.state {
            case .withButton, .onLoading:
                Group {
                    LoadingButton(
                        text: "View replies",
                        action: {
                            Task {
                                await viewModel.getComments(for: comment.id)
                            }
                        },
                        isLoading: comment.state == .onLoading
                    )
                    
                    Divider()
                        .frame(height: 1)
                }
                .padding(.leading, basePadding)
            case .noReplies:
                Divider()
                    .frame(height: 1)
                    .padding(.leading, basePadding)
            case .replies:
                Divider()
                    .frame(height: 1)
                    .padding(.leading, repliesPadding)
            }
        }
    }
}
