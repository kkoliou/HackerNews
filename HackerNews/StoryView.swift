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
        VStack(alignment: .leading, spacing: 12
        ) {
            HStack {
                Text(viewModel.title)
                    .font(.headline)
                Spacer()
            }
            
            textWithIcon(
                icon: "link",
                text: viewModel.link
            )
            .padding(.bottom, 8)
            
            HStack(spacing: 16) {
                textWithIcon(
                    icon: "arrow.up.right",
                    text: "\(viewModel.points) pts"
                )
                
                textWithIcon(
                    icon: "person",
                    text: viewModel.author
                )
                
                Spacer()
            }
            
            HStack(spacing: 16) {
                textWithIcon(
                    icon: "clock",
                    text: "\(viewModel.dateAgo) ago"
                )
                
                textWithIcon(
                    icon: "message",
                    text: "\(viewModel.comments) comments"
                )
            }
        }
        .padding()
        .background(
            Material.thickMaterial,
            in: RoundedRectangle(cornerRadius: 24, style: .circular)
        )
    }
    
    func textWithIcon(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(text)
        }
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
