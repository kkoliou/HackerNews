//
//  DomainItem.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 16/10/25.
//

import Foundation

public struct DomainItem: Sendable, Identifiable, Hashable {
    public let id: Int?
    public let title: String?
    public let author: String?
    public let url: URL?
    public let type: String?
    public let score: Int?
    public let descendants: Int?
    public let kids: [Int]?
    public let time: Date?
    public let text: String?
    
    public init(
        id: Int?,
        title: String?,
        author: String?,
        url: URL?,
        type: String?,
        score: Int?,
        descendants: Int?,
        kids: [Int]?,
        time: Date?,
        text: String?
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.url = url
        self.type = type
        self.score = score
        self.descendants = descendants
        self.kids = kids
        self.time = time
        self.text = text
    }
}
