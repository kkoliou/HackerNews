//
//  StoriesView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import SwiftUI
import HackerNewsClient

struct StoriesView: View {
    
    @Environment(\.navigate) private var navigate
    @Environment(\.openURL) var openURL
    @Bindable var viewModel: StoriesViewModel
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else {
                content
            }
        }
        .navigationTitle(viewModel.selectedCategory.rawValue.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Stories", selection: $viewModel.selectedCategory) {
                        ForEach(StoriesCategory.allCases) { category in
                            Text(category.rawValue.capitalized)
                                .tag(category)
                        }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .tint(.primary)
                }
            }
        }
        .task {
            await viewModel.fetchInitialData()
        }
        .onChange(of: viewModel.selectedCategory) { oldValue, newValue in
            if newValue != oldValue {
                Task {
                    await viewModel.fetchData()
                }
            }
        }
    }
    
    var content: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(viewModel.stories, id: \.id) { story in
                    StoryView(
                        story: story,
                        onCommentsTap: {
                            navigate.push(to: .comments(story: story))
                        },
                        onLinkTap: {
                            guard let url = story.url else { return }
                            openURL.open(url)
                        }
                    )
                    .onAppear {
                        guard let id = story.id else { return }
                        Task {
                            await viewModel.fetchNextBatchIfNeeded(currentItemId: id)
                        }
                    }
                }
                
                if viewModel.isPagingLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .id(viewModel.stories.count) // used to rerender that loader
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    let storage = StoriesStorage(
        stories: [
            DomainItem(
                id: 45622204,
                title: "title",
                author: "author",
                url: nil,
                type: nil,
                score: nil,
                descendants: nil,
                kids: nil,
                time: nil,
                text: nil
            ),
            DomainItem(
                id: 45622199,
                title: "title2",
                author: "author2",
                url: nil,
                type: nil,
                score: nil,
                descendants: nil,
                kids: nil,
                time: nil,
                text: nil
            )
        ]
    )
    let viewModel = StoriesViewModel(
        client: HackerNewsClientMock(
            storage: storage,
            topStories: [45622204, 45622199]
        )
    )
    StoriesView(viewModel: viewModel)
}
