//
//  CommentsStoryView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 26/11/25.
//

import SwiftUI
import HackerNewsClient

struct CommentsStoryView: View {
    
    let story: DomainItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(story.title ?? "")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 16) {
                if let score = story.score {
                    TextWithIcon(
                        icon: "arrow.up.right",
                        text: "\(score) pts"
                    )
                    .layoutPriority(3)
                }
                
                if let author = story.author {
                    TextWithIcon(
                        icon: "person",
                        text: author
                    )
                    .minimumScaleFactor(0.7)
                    .layoutPriority(1)
                }
                
                if let dateAgo = story.getTimeAgo() {
                    TextWithIcon(
                        icon: "clock",
                        text: "\(dateAgo) ago"
                    )
                    .layoutPriority(2)
                }
            }
        }
    }    
}
