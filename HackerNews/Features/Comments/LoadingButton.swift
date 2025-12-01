//
//  LoadingButton.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 1/12/25.
//

import SwiftUI

struct LoadingButton: View {
    
    let text: String
    let action: () -> Void
    let isLoading: Bool
    
    var body: some View {
        Button(
            action: {
                if !isLoading { action() }
            },
            label: {
                ZStack {
                    Text(text)
                        .font(.system(size: 16, weight: .semibold))
                        .opacity(isLoading ? 0 : 1)
                    
                    if isLoading {
                        ProgressView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemGray6))
                )
            }
        )
        .foregroundColor(.primary)
        .disabled(isLoading)
    }
}
