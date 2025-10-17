//
//  StoryResponse.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import Foundation

struct StoryResponse: Decodable, Equatable {
    
    let id: Int
    let title: String?
    let author: String
    let url: URL?
    let type: String?
    let score: Int?
    let descendants: Int?
    let kids: [Int]?
    let time: Date?

    enum CodingKeys: String, CodingKey {
        case id, title, url, type, score, kids
        case author = "by"
        case descendants
        case time
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.author = try container.decode(String.self, forKey: .author)
        
        if let urlString = try container.decodeIfPresent(String.self, forKey: .url) {
            self.url = URL(string: urlString)
        } else {
            self.url = nil
        }
        
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.score = try container.decodeIfPresent(Int.self, forKey: .score)
        self.descendants = try container.decodeIfPresent(Int.self, forKey: .descendants)
        self.kids = try container.decodeIfPresent([Int].self, forKey: .kids)
        
        if let timeInt = try? container.decode(Int.self, forKey: .time) {
            self.time = Date(timeIntervalSince1970: TimeInterval(timeInt))
        } else {
            self.time = nil
        }
    }
    
    func toDomain() -> DomainStory {
        return DomainStory(
            id: id,
            title: title,
            author: author,
            url: url,
            type: type,
            score: score,
            descendants: descendants,
            kids: kids,
            time: time
        )
    }
}
