//
//  StoriesView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import SwiftUI
import HackerNewsClient

@Observable
class StoriesViewModel {
    
    var stories = [DomainStory]()
    var isLoading = false
    var selectedCategory: StoriesCategory = .top
    
    private let client: HackerNewsClientProtocol
    
    init(client: HackerNewsClientProtocol) {
        self.client = client
    }
    
    func fetchData() async {
        isLoading = true
        let ids = try? await fetchStoryIds(for: selectedCategory)
        let stories = await client.getItems(ids: ids ?? [])
        isLoading = false
        self.stories = stories
    }
    
    private func fetchStoryIds(for category: StoriesCategory) async throws -> [Int] {
        switch category {
        case .top:
            return try await client.getTopStories()
        case .new:
            return try await client.getNewStories()
        case .best:
            return try await client.getBestStories()
        case .ask:
            return try await client.getAskStories()
        case .show:
            return try await client.getShowStories()
        case .job:
            return try await client.getJobStories()
        }
    }
}

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
        List(viewModel.stories) {
            StoryView(story: $0)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
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
