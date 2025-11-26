//
//  OpenURLAction+.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 26/11/25.
//

import SwiftUI

extension OpenURLAction {
    func open(_ url: URL) {
        if #available(iOS 26.0, *) {
            self(url, prefersInApp: true)
        } else {
            self(url)
        }
    }
}
