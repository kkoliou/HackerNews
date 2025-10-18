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
    
    private let client: HackerNewsClientProtocol
    
    init(client: HackerNewsClientProtocol) {
        self.client = client
    }
    
    func fetchTopStories() async {
        let topStoriesIds = try? await client.getTopStories()
        let bestStories = await client.getItems(ids: topStoriesIds ?? [])
        stories = bestStories
    }
}

struct StoriesView: View {
    
    @Bindable var viewModel: StoriesViewModel
    
    var body: some View {
        List(viewModel.stories) {
            StoryView(story: $0)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .task {
            await viewModel.fetchTopStories()
        }
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
