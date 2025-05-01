// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum RedHatDisplay {
    internal static let black = FontConvertible(name: "RedHatDisplay-Black", family: "Red Hat Display", path: "RedHatDisplay-Black.ttf")
    internal static let blackItalic = FontConvertible(name: "RedHatDisplay-BlackItalic", family: "Red Hat Display", path: "RedHatDisplay-BlackItalic.ttf")
    internal static let bold = FontConvertible(name: "RedHatDisplay-Bold", family: "Red Hat Display", path: "RedHatDisplay-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "RedHatDisplay-BoldItalic", family: "Red Hat Display", path: "RedHatDisplay-BoldItalic.ttf")
    internal static let extraBold = FontConvertible(name: "RedHatDisplay-ExtraBold", family: "Red Hat Display", path: "RedHatDisplay-ExtraBold.ttf")
    internal static let extraBoldItalic = FontConvertible(name: "RedHatDisplay-ExtraBoldItalic", family: "Red Hat Display", path: "RedHatDisplay-ExtraBoldItalic.ttf")
    internal static let italic = FontConvertible(name: "RedHatDisplay-Italic", family: "Red Hat Display", path: "RedHatDisplay-Italic.ttf")
    internal static let light = FontConvertible(name: "RedHatDisplay-Light", family: "Red Hat Display", path: "RedHatDisplay-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "RedHatDisplay-LightItalic", family: "Red Hat Display", path: "RedHatDisplay-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "RedHatDisplay-Medium", family: "Red Hat Display", path: "RedHatDisplay-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "RedHatDisplay-MediumItalic", family: "Red Hat Display", path: "RedHatDisplay-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "RedHatDisplay-Regular", family: "Red Hat Display", path: "RedHatDisplay-Regular.ttf")
    internal static let semiBold = FontConvertible(name: "RedHatDisplay-SemiBold", family: "Red Hat Display", path: "RedHatDisplay-SemiBold.ttf")
    internal static let semiBoldItalic = FontConvertible(name: "RedHatDisplay-SemiBoldItalic", family: "Red Hat Display", path: "RedHatDisplay-SemiBoldItalic.ttf")
    internal static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, extraBold, extraBoldItalic, italic, light, lightItalic, medium, mediumItalic, regular, semiBold, semiBoldItalic]
  }
  internal enum RedHatText {
    internal static let bold = FontConvertible(name: "RedHatText-Bold", family: "Red Hat Text", path: "RedHatText-Bold.ttf")
    internal static let light = FontConvertible(name: "RedHatText-Light", family: "Red Hat Text", path: "RedHatText-Light.ttf")
    internal static let medium = FontConvertible(name: "RedHatText-Medium", family: "Red Hat Text", path: "RedHatText-Medium.ttf")
    internal static let regular = FontConvertible(name: "RedHatText-Regular", family: "Red Hat Text", path: "RedHatText-Regular.ttf")
    internal static let semiBold = FontConvertible(name: "RedHatText-SemiBold", family: "Red Hat Text", path: "RedHatText-SemiBold.ttf")
    internal static let all: [FontConvertible] = [bold, light, medium, regular, semiBold]
  }
  internal static let allCustomFonts: [FontConvertible] = [RedHatDisplay.all, RedHatText.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  internal func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
internal extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
