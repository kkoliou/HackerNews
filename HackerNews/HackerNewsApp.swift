//
//  HackerNewsApp.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 24/9/25.
//

import SwiftUI
import HackerNewsClient

@main
struct HackerNewsApp: App {
    
    @Bindable private var navigationRouter = NavigationRouter.shared
    @Bindable private var viewModel = StoriesViewModel(client: HackerNewsClientLive())
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationRouter.routes) {
                StoriesView(
                    viewModel: viewModel
                )
                .navigationDestination(for: Route.self, destination: { route in
                    Routes(route: route)
                })
                .environment(\.navigate, navigationRouter)
            }
        }
    }
}
