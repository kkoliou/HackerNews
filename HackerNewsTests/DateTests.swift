//
//  DateTests.swift
//  HackerNewsTests
//
//  Created by Konstantinos Kolioulis on 1/10/25.
//

import Testing
import Foundation
@testable import HackerNews

struct DateTests {
    
    @Test func `just now for dates less than a minute ago`() async throws {
        let date = Date().addingTimeInterval(-30) // 30 seconds ago
        #expect(date.timeAgoFromNow() == "Just now")
    }
    
    @Test func `single minute ago`() async throws {
        let date = Date().addingTimeInterval(-60) // 1 minute ago
        #expect(date.timeAgoFromNow() == "1 minute")
    }
    
    @Test func `multiple minutes ago`() async throws {
        let date = Date().addingTimeInterval(-5 * 60) // 5 minutes ago
        #expect(date.timeAgoFromNow() == "5 minutes")
    }
    
    @Test func `single hour without rounding`() async throws {
        let date = Date().addingTimeInterval(-65 * 60) // 1 hour 5 minutes ago
        #expect(date.timeAgoFromNow() == "1 hour")
    }
    
    @Test func `single hour rounds up to 2 hours`() async throws {
        let date = Date().addingTimeInterval(-90 * 60) // 1 hour 30 minutes ago
        #expect(date.timeAgoFromNow() == "2 hours")
    }
    
    @Test func `multiple hours without rounding`() async throws {
        let date = Date().addingTimeInterval(-3 * 3600) // 3 hours ago
        #expect(date.timeAgoFromNow() == "3 hours")
    }
    
    @Test func `hours round up based on minutes`() async throws {
        let date = Date().addingTimeInterval(-(5 * 3600 + 45 * 60)) // 5 hours 45 minutes ago
        #expect(date.timeAgoFromNow() == "6 hours")
    }
    
    @Test func `single day without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result == "1 day" || result == "2 days") // May round based on exact time
    }
    
    @Test func `multiple days without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result.contains("day") || result.contains("days"))
    }
    
    @Test func `days round up based on hours`() async throws {
        let date = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
            .addingTimeInterval(-13 * 3600) // 2 days 13 hours ago
        #expect(date.timeAgoFromNow() == "3 days")
    }
    
    @Test func `single week without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result == "1 week" || result == "2 weeks")
    }
    
    @Test func `multiple weeks without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result.contains("week"))
    }
    
    @Test func `weeks round up based on days`() async throws {
        let date = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!
        let dateWithExtraDays = Calendar.current.date(byAdding: .day, value: -4, to: date)!
        #expect(dateWithExtraDays.timeAgoFromNow() == "3 weeks")
    }
    
    @Test func `single month without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result == "1 month" || result == "2 months")
    }
    
    @Test func `multiple months without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result.contains("month"))
    }
    
    @Test func `months round up based on weeks`() async throws {
        let date = Calendar.current.date(byAdding: .month, value: -5, to: Date())!
        let dateWithExtraWeeks = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: date)!
        #expect(dateWithExtraWeeks.timeAgoFromNow() == "6 months")
    }
    
    @Test func `single year without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result == "1 year")
    }
    
    @Test func `multiple years without rounding`() async throws {
        let date = Calendar.current.date(byAdding: .year, value: -3, to: Date())!
        let result = date.timeAgoFromNow()
        #expect(result.contains("year"))
    }
    
    @Test func `years round up based on months`() async throws {
        let date = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        let dateWithExtraMonths = Calendar.current.date(byAdding: .month, value: -7, to: date)!
        #expect(dateWithExtraMonths.timeAgoFromNow() == "3 years")
    }
    
    @Test func `years round down based on months`() async throws {
        let date = Calendar.current.date(byAdding: .year, value: -2, to: Date())!
        let dateWithExtraMonths = Calendar.current.date(byAdding: .month, value: -3, to: date)!
        #expect(dateWithExtraMonths.timeAgoFromNow() == "2 years")
    }

    @Test func `29 minutes ago does not round to 1 hour`() async throws {
        let date = Date().addingTimeInterval(-29 * 60) // 29 minutes
        #expect(date.timeAgoFromNow() == "29 minutes")
    }

    @Test func `11 hours ago does not round to 1 day`() async throws {
        let date = Date().addingTimeInterval(-11 * 3600) // 11 hours
        #expect(date.timeAgoFromNow() == "11 hours")
    }
}
