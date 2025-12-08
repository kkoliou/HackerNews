//
//  AttributedString+.swift
//  HackerNews
//
//  Created by Konstantinos Kolioulis on 25/11/25.
//

import UIKit

extension AttributedString {
    init?(html: String) {
        guard let data = html.data(using: .utf8) else { return nil }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let nsAttr = try? NSMutableAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else { return nil }

        let fullRange = NSRange(location: 0, length: nsAttr.length)

        // Default fonts
        let baseFont = UIFont.systemFont(ofSize: 16)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let italicFont = UIFont.italicSystemFont(ofSize: 16)

        // Default paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.paragraphSpacingBefore = 4
        paragraphStyle.paragraphSpacing = 8

        // Apply default to everything FIRST
        nsAttr.addAttributes([
            .font: baseFont,
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ], range: fullRange)

        // Apply bold & italic overrides
        nsAttr.enumerateAttributes(
            in: fullRange,
            options: []
        ) { attrs, range, _ in
            if let font = attrs[.font] as? UIFont {
                let traits = font.fontDescriptor.symbolicTraits
                
                if traits.contains(.traitBold) {
                    nsAttr.addAttribute(.font, value: boldFont, range: range)
                }
                if traits.contains(.traitItalic) {
                    nsAttr.addAttribute(.font, value: italicFont, range: range)
                }
            }
        }

        // Style links
        nsAttr.enumerateAttribute(
            .link,
            in: fullRange,
            options: []
        ) { value, range, _ in
            guard value != nil else { return }
            
            nsAttr.addAttributes([
                .foregroundColor: UIColor.systemBlue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: range)
        }

        self.init(nsAttr)
    }
}
