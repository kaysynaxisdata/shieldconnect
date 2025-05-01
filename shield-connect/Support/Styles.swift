//
//  Styles.swift
//  shield-connect
//
//  Created by Александр on 01.04.2025.
//

import Foundation
import SwiftUI

enum TextWeightStyle {
    case regular
    case medium
    case semibold
    case bold
    case black
    
    var weight: FontConvertible {
        switch self {
        case .regular:
            return FontFamily.RedHatDisplay.regular
        case .medium:
            return FontFamily.RedHatDisplay.medium
        case .semibold:
            return FontFamily.RedHatDisplay.semiBold
        case .bold:
            return FontFamily.RedHatDisplay.bold
        case .black:
            return FontFamily.RedHatDisplay.black
        }
    }
}

enum FontStyle {
    
    case titleLarge
    case custom(style: TextWeightStyle, size: CGFloat)
    
    var font: UIFont {
        switch self {
        case .titleLarge:
            return FontFamily.RedHatDisplay.black.font(size: 64)
        case .custom(let style, let size):
            return style.weight.font(size: size)
        }
    }
    
    var swiftUIFont: SwiftUI.Font {
        switch self {
        case .titleLarge:
            return FontFamily.RedHatDisplay.black.swiftUIFont(size: 64)
        case .custom(let style, let size):
            return style.weight.swiftUIFont(size: size)
        }
    }
    
}

struct TextStyle {
    var fontStyle: FontStyle
    var lineHeight: CGFloat
    var colorAsset: ColorAsset
}

// MARK: - UILabel+Style
extension UILabel {
    func apply(style: TextStyle, string: String? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        
        let lineHeight = style.lineHeight
        let targetLineHeight = style.fontStyle.font.lineHeight
        
        let spacing = lineHeight - targetLineHeight
        paragraphStyle.lineSpacing = spacing
        
        let labelText = self.text ?? ""
        let string = string ?? labelText
        
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(
            .font,
            value: style.fontStyle.font,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .foregroundColor,
            value: style.colorAsset.color,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        
        self.attributedText = attributedString
    }
    
}

// MARK: - Text Style Extensions
extension Text {
    func applyStyle(style: TextStyle) -> some View {
        self
            .foregroundColor(style.colorAsset.swiftUIColor)
            .font(style.fontStyle.swiftUIFont)
            .lineSpacing(CGFloat(style.lineHeight - style.fontStyle.font.lineHeight))
    }
}

// MARK: - View Style Extensions
extension View {
    func applyStyle(style: TextStyle) -> some View {
        self
            .foregroundColor(style.colorAsset.swiftUIColor)
            .font(style.fontStyle.swiftUIFont)
    }
}

// MARK: - Styles.Values
//extension Styles.Values {
//    struct Spacing {
//        static let xxs: CGFloat = 2
//        static let xs: CGFloat = 4
//        static let sm: CGFloat = 8
//        static let md: CGFloat = 12
//        static let lg: CGFloat = 16
//        static let xl: CGFloat = 24
//        static let xxl: CGFloat = 32
//    }
//    
//    struct BorderWidth {
//        static let thin: CGFloat = 1
//        static let regular: CGFloat = 2
//        static let thick: CGFloat = 3
//    }
//}
