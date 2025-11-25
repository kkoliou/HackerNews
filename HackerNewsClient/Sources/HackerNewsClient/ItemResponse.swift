//
//  ItemResponse.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import Foundation

struct ItemResponse: Decodable, Equatable {
    
    let id: Int?
    let title: String?
    let author: String?
    let url: URL?
    let type: String?
    let score: Int?
    let descendants: Int?
    let kids: [Int]?
    let time: Date?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case id, title, url, type, score, kids
        case author = "by"
        case descendants
        case time
        case text
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        
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
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
    }
    
    func toDomain() -> DomainItem {
        return DomainItem(
            id: id,
            title: title,
            author: author,
            url: url,
            type: type,
            score: score,
            descendants: descendants,
            kids: kids,
            time: time,
            text: text
        )
    }
}
