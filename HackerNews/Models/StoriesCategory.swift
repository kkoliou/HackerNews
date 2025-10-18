//
//  StoriesCategory.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 18/10/25.
//

import Foundation

enum StoriesCategory: String, CaseIterable, Identifiable {
    case top, new, best, ask, show, job
    var id: Self { self }
}
