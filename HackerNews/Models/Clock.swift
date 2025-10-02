//
//  Clock.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 1/10/25.
//

import Foundation

protocol Clock {
    var now: Date { get }
}

struct SystemClock: Clock {
    var now: Date { Date() }
}

struct ClockProvider {
    static var shared: Clock = SystemClock()
}
