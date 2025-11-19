//
//  StoryView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 24/9/25.
//

import SwiftUI
import HackerNewsClient

struct StoryView: View {
    
    let story: DomainStory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(story.title ?? "")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 16) {
                if let score = story.score {
                    textWithIcon(
                        icon: "arrow.up.right",
                        text: "\(score) pts"
                    )
                    .layoutPriority(3)
                }
                
                if let author = story.author {
                    textWithIcon(
                        icon: "person",
                        text: author
                    )
                    .minimumScaleFactor(0.7)
                    .layoutPriority(1)
                }
                
                if let dateAgo = story.getTimeAgo() {
                    textWithIcon(
                        icon: "clock",
                        text: "\(dateAgo) ago"
                    )
                    .layoutPriority(2)
                }
            }
            
            HStack(spacing: 16) {
                buttonFor(
                    icon: "message",
                    text: "\(story.descendants ?? 0) comments",
                    action: {}
                )
                .foregroundStyle(.orange)
                
                if let url = story.getDomainUrl(), !url.isEmpty {
                    buttonFor(
                        icon: "link",
                        text: url,
                        action: {}
                    )
                    .foregroundStyle(.blue)
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 12)
        .background(
            Material.thickMaterial,
            in: RoundedRectangle(cornerRadius: 24, style: .circular)
        )
    }
    
    func textWithIcon(
        icon: String,
        text: String,
        spacing: CGFloat = 8
    ) -> some View {
        HStack(spacing: spacing) {
            Image(systemName: icon)
            Text(text)
                .lineLimit(1)
        }
    }
    
    func buttonFor(
        icon: String,
        text: String,
        action: @escaping (() -> Void)
    ) -> some View {
        Button(
            action: action,
            label: {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                    Text(text)
                        .minimumScaleFactor(0.7)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        )
        .interactiveGlassEffect()
        .frame(height: 48)
    }
}

#Preview {
    var components = DateComponents()
    components.year = 2024
    components.month = 5
    components.day = 20
    components.hour = 14
    components.minute = 30
    components.second = 0
    let mockDate = Calendar.current.date(from: components)!
    
    return StoryView(
        story: .init(
            id: 43,
            title: "title",
            author: "authorrrrrrrrrrrrrrrrrrrrrrr",
            url: URL(string: "https://www.example.com?temp=25"),
            type: "",
            score: 5,
            descendants: 5,
            kids: nil,
            time: mockDate
        )
    )
    .padding(.horizontal, 16)
}
