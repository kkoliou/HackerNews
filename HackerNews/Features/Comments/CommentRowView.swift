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
    
    var body: some View {
        LazyVStack(alignment: .leading) {
            Divider()
                .frame(height: 1)
            
            HStack {
                Text(comment.attributedText)
                Spacer()
            }
            
            switch comment.state {
            case .withButton, .onLoading:
                LoadingButton(
                    text: "View replies",
                    action: {
                        Task {
                            await viewModel.getComments(for: comment.id)
                        }
                    },
                    isLoading: comment.state == .onLoading
                )
            default:
                EmptyView()
            }
        }
        .padding(.leading, CGFloat(comment.level * 16))
        .onAppear {
            Task {
                await viewModel.fetchNextBatchIfNeeded(currentItemId: comment.id)
            }
        }
    }
}
