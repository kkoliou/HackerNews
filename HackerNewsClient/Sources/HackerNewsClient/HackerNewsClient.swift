//
//  HackerNewsClient.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 16/10/25.
//

import Foundation

public protocol HackerNewsClientProtocol: Sendable {
    func getTopStories() async throws -> [Int]
    func getNewStories() async throws -> [Int]
    func getBestStories() async throws -> [Int]
    func getJobStories() async throws -> [Int]
    func getAskStories() async throws -> [Int]
    func getShowStories() async throws -> [Int]
    func getItem(id: Int) async throws -> DomainStory
    func getItems(ids: [Int]) async -> [DomainStory]
}
