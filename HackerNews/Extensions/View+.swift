//
//  View+.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func defaultButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.automatic)
        }
    }
}
