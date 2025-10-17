//
//  ContentView.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 24/9/25.
//

import SwiftUI
import HackerNewsClient

struct ContentView: View {
    var body: some View {
        StoriesView(viewModel: StoriesViewModel(client: HackerNewsClientLive()))
    }
}

#Preview {
    ContentView()
}
