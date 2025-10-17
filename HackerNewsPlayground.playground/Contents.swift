import UIKit
import HackerNewsClient

Task {
    let data = HackerNewsClientLive()
    let ids = try await data.getTopStories()
    await data.getItems(ids: ids)
}
