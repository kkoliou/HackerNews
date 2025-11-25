//
//  NavigationRouter.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 23/11/25.
//

import SwiftUI
import HackerNewsClient

@Observable
class NavigationRouter {
    
    static let shared = NavigationRouter()
    
    var routes = [Route]()

    func push(to view: Route) {
        routes.append(view)
    }

    func reset() {
        routes = []
    }

    func navigateBack() {
        _ = routes.popLast()
    }
}

enum Route: Hashable {
    case comments(story: DomainItem)
}

struct Routes: View {
    let route: Route
 
    var body: some View {
        switch route {
        case .comments(let story):
            StoryCommentsView(viewModel: .init(client: HackerNewsClientLive(), story: story))
        }
    }
}

struct NavigationEnvironmentKey: EnvironmentKey {
    static var defaultValue: NavigationRouter = .init()
}

extension EnvironmentValues {
    var navigate: NavigationRouter {
        get { self[NavigationEnvironmentKey.self] }
        set { self[NavigationEnvironmentKey.self] = newValue }
    }
}
