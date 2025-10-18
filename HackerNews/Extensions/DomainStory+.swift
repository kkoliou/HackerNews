//
//  DomainStory+.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 18/10/25.
//

import Foundation
import HackerNewsClient

extension DomainStory {
    func getTimeAgo(from date: Date = Date.current) -> String? {
        time?.timeAgoFromNow()
    }
    
    func getDomainUrl() -> String? {
        url?.absoluteString.domainUrl
    }
}
