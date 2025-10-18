//
//  Date+.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 1/10/25.
//

import Foundation

extension Date {
    func timeAgoFromNow(_ now: Date = Date.current) -> String {
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute],
            from: self,
            to: now
        )
        
        if let years = components.year, years > 0 {
            let rounded = years + (components.month ?? 0 >= 6 ? 1 : 0)
            return "\(rounded) \(rounded == 1 ? "year" : "years")"
        }
        
        if let months = components.month, months > 0 {
            let rounded = months + (components.weekOfYear ?? 0 >= 2 ? 1 : 0)
            return "\(rounded) \(rounded == 1 ? "month" : "months")"
        }
        
        if let weeks = components.weekOfYear, weeks > 0 {
            let rounded = weeks + (components.day ?? 0 >= 4 ? 1 : 0)
            return "\(rounded) \(rounded == 1 ? "week" : "weeks")"
        }
        
        if let days = components.day, days > 0 {
            let rounded = days + (components.hour ?? 0 >= 12 ? 1 : 0)
            return "\(rounded) \(rounded == 1 ? "day" : "days")"
        }
        
        if let hours = components.hour, hours > 0 {
            let rounded = hours + (components.minute ?? 0 >= 30 ? 1 : 0)
            return "\(rounded) \(rounded == 1 ? "hour" : "hours")"
        }
        
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "minute" : "minutes")"
        }
        
        return "Just now"
    }
    
    static var current: Date {
        ClockProvider.shared.now
    }
}
