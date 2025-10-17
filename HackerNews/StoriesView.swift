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
    var stories = [Story]()
    
    private let client: HackerNewsClientProtocol
    
    init(client: HackerNewsClientProtocol) {
        self.client = client
    }
    
    func fetchTopStories() async {
        let topStoriesIds = try? await client.getTopStories()
        let bestStories = await client.getItems(ids: topStoriesIds ?? [])
        stories = bestStories.map({ Story(domainStory: $0) })
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
    let story = DomainStory(
        id: 45622204,
        title: "title",
        author: "",
        url: nil,
        type: nil,
        score: nil,
        descendants: nil,
        kids: nil,
        time: nil
    )
    let storage = StoriesStorage(stories: [story])
    let viewModel = StoriesViewModel(client: HackerNewsClientMock(storage: storage))
    StoriesView(viewModel: viewModel)
}
