//
//  Strings+.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 1/10/25.
//

import Foundation

extension String {
    var domainUrl: String? {
        guard let url = URL(string: self),
              let host = url.host()
        else { return nil }
        
        let domain = host.replacingOccurrences(
            of: "^www.",
            with: "",
            options: .regularExpression
        )
        
        return domain
    }
}
