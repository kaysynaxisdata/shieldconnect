// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let accentColor = ColorAsset(name: "AccentColor")
  internal static let mainAdditional = ColorAsset(name: "main.additional")
  internal static let mainBgblack = ColorAsset(name: "main.bgblack")
  internal static let mainCountry = ColorAsset(name: "main.country")
  internal static let mainGreen = ColorAsset(name: "main.green")
  internal static let mainGrey = ColorAsset(name: "main.grey")
  internal static let mainLightblue = ColorAsset(name: "main.lightblue")
  internal static let mainLightgrey = ColorAsset(name: "main.lightgrey")
  internal static let mainPurple = ColorAsset(name: "main.purple")
  internal static let mainSecondary = ColorAsset(name: "main.secondary")
  internal static let mainText = ColorAsset(name: "main.text")
  internal static let navigationBack = ColorAsset(name: "navigation.back")
  internal static let promoBackground = ColorAsset(name: "promo.background")
  internal static let promoDark = ColorAsset(name: "promo.dark")
  internal static let promoShadow = ColorAsset(name: "promo.shadow")
  internal static let promoSpacer = ColorAsset(name: "promo.spacer")
  internal static let whiteColor = ColorAsset(name: "whiteColor")
  internal static let back = ImageAsset(name: "back")
  internal static let backgroundEffects = ImageAsset(name: "background-effects")
  internal static let backgroundImage = ImageAsset(name: "backgroundImage")
  internal static let checkCircleFilled = ImageAsset(name: "check-circle-filled")
  internal static let checkCircle = ImageAsset(name: "check-circle")
  internal static let commonLogo = ImageAsset(name: "common-logo")
  internal static let mainArrowRight = ImageAsset(name: "main-arrow-right")
  internal static let mainChevronRight = ImageAsset(name: "main-chevron-right")
  internal static let mainConnectButton = ImageAsset(name: "main-connect-button")
  internal static let mainDisconnectButton = ImageAsset(name: "main-disconnect-button")
  internal static let mainPowerConnection = ImageAsset(name: "main-power-connection")
  internal static let mainSettings = ImageAsset(name: "main-settings")
  internal static let mainShield = ImageAsset(name: "main-shield")
  internal static let mainStartConnection = ImageAsset(name: "main-start-connection")
  internal static let passcodeBack = ImageAsset(name: "passcode-back")
  internal static let passcodeX = ImageAsset(name: "passcode-x")
  internal static let paywallBg = ImageAsset(name: "paywall-bg")
  internal static let paywallClose = ImageAsset(name: "paywall-close")
  internal static let signalBlue = ImageAsset(name: "signal-blue")
  internal static let signalGood = ImageAsset(name: "signal-good")
  internal static let signalRed = ImageAsset(name: "signal-red")
  internal static let signalYellow = ImageAsset(name: "signal-yellow")
  internal static let settingBannerBg = ImageAsset(name: "setting-banner-bg")
  internal static let settingChat = ImageAsset(name: "setting-chat")
  internal static let settingChevronLight = ImageAsset(name: "setting-chevron-light")
  internal static let settingCompass = ImageAsset(name: "setting-compass")
  internal static let settingCrown = ImageAsset(name: "setting-crown")
  internal static let settingFaceid = ImageAsset(name: "setting-faceid")
  internal static let settingFolder = ImageAsset(name: "setting-folder")
  internal static let settingRefresh = ImageAsset(name: "setting-refresh")
  internal static let speedcheckerAngular = ImageAsset(name: "speedchecker-angular")
  internal static let speedcheckerDownload = ImageAsset(name: "speedchecker-download")
  internal static let speedcheckerIp = ImageAsset(name: "speedchecker-ip")
  internal static let speedcheckerPing = ImageAsset(name: "speedchecker-ping")
  internal static let speedcheckerThumb = ImageAsset(name: "speedchecker-thumb")
  internal static let speedcheckerUpload = ImageAsset(name: "speedchecker-upload")
  internal static let promoLogo = ImageAsset(name: "promo-logo")
  internal static let splashBackground = ImageAsset(name: "splash-background")
  internal static let splashGlow = ImageAsset(name: "splash-glow")
  internal static let splashProgress = ImageAsset(name: "splash-progress")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
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
