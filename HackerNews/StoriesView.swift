//
//  StoriesView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import SwiftUI
import HackerNewsClient

struct StoriesView: View {
    
    @Bindable var viewModel: StoriesViewModel
    
    var body: some View {
        NavigationStack {
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
                await viewModel.fetchData()
            }
            .onChange(of: viewModel.selectedCategory) { oldValue, newValue in
                if newValue != oldValue {
                    Task {
                        await viewModel.fetchData()
                    }
                }
            }
        }
    }
    
    var content: some View {
        List {
            ForEach(viewModel.stories) { story in
                StoryView(story: story)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
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
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let storage = StoriesStorage(
        stories: [
            DomainStory(
                id: 45622204,
                title: "title",
                author: "author",
                url: nil,
                type: nil,
                score: nil,
                descendants: nil,
                kids: nil,
                time: nil
            ),
            DomainStory(
                id: 45622199,
                title: "title2",
                author: "author2",
                url: nil,
                type: nil,
                score: nil,
                descendants: nil,
                kids: nil,
                time: nil
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
