//
//  View+.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 8/10/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func identityInteractiveGlassEffect() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.identity.interactive())
        } else {
            self
        }
    }
}
