//
//  CommentsThreadView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 26/11/25.
//

import SwiftUI
import HackerNewsClient

struct CommentsThreadView: View {
    
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.attributedText)
                Spacer()
            }
            
            ForEach(comment.comments) { child in
                CommentsThreadView(comment: child)
                    .padding(.leading, 16)
            }
        }
        .padding(16)
        .background(
            Material.thickMaterial,
            in: RoundedRectangle(cornerRadius: 24, style: .circular)
        )
    }
}

struct Comment: Identifiable {
    var id: Int { comment.id ?? 0 }
    let comment: DomainItem
    let comments: [Comment]
    let attributedText: AttributedString
}
