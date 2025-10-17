//
//  Story.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import Foundation
import HackerNewsClient

class Story: Identifiable {
    var title: String
    var link: String
    var points: Int
    var author: String
    var dateAgo: String
    var comments: Int
    
    init(domainStory: DomainStory) {
        self.title = domainStory.title ?? ""
        self.link = domainStory.url?.absoluteString.domainUrl ?? ""
        self.points = domainStory.score ?? 0
        self.author = domainStory.author
        self.dateAgo = domainStory.time?.timeAgoFromNow() ?? ""
        self.comments = domainStory.descendants ?? 0
    }
    
    init(
        title: String,
        link: String,
        points: Int,
        author: String,
        date: Date,
        comments: Int
    ) {
        self.title = title
        self.link = link.domainUrl ?? ""
        self.points = points
        self.author = author
        self.dateAgo = date.timeAgoFromNow()
        self.comments = comments
    }
}
