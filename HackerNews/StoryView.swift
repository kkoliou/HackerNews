//
//  StoryView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 24/9/25.
//

import SwiftUI

@Observable
class StoryViewModel {
    var title: String
    var link: String
    var points: Int
    var author: String
    var dateAgo: String
    var comments: Int
    
    init(
        title: String,
        link: String,
        points: Int,
        author: String,
        date: Date,
        comments: Int
    ) {
        self.title = title
        self.link = link.domainUrl ?? ""
        self.points = points
        self.author = author
        self.dateAgo = date.timeAgoFromNow()
        self.comments = comments
    }
}

struct StoryView: View {
    
    @Bindable var viewModel: StoryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.title)
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 16) {
                textWithIcon(
                    icon: "arrow.up.right",
                    text: "\(viewModel.points) pts"
                )
                
                textWithIcon(
                    icon: "person",
                    text: viewModel.author
                )
                
                textWithIcon(
                    icon: "clock",
                    text: "\(viewModel.dateAgo) ago"
                )
            }
            
            HStack(spacing: 16) {
                buttonFor(
                    icon: "message",
                    text: "\(viewModel.comments) comments",
                    action: {}
                )
                .foregroundStyle(.orange)
                
                buttonFor(
                    icon: "link",
                    text: viewModel.link,
                    action: {}
                )
                .foregroundStyle(.blue)
            }
            .padding(.top, 8)
        }
        .padding()
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
        .glassEffect()
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
        viewModel: .init(
            title: "title",
            link: "https://www.example.com?temp=25",
            points: 5,
            author: "author",
            date: mockDate,
            comments: 5
        )
    )
    .padding(.horizontal, 16)
}
