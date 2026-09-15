import Flutter
import UIKit
import SwiftUI
import PaymentSDK

public class FlutterAlinmapayPaymentPlugin: NSObject, FlutterPlugin {

  private var flutterResult: FlutterResult?
  private var registrar: FlutterPluginRegistrar?
  public static func register(with registrar: FlutterPluginRegistrar) {

    let channel = FlutterMethodChannel(
      name: "flutter_alinmapay_payment",
      binaryMessenger: registrar.messenger()
    )

    let instance = FlutterAlinmapayPaymentPlugin()

    // Store registrar so Flutter assets can be resolved later
    instance.registrar = registrar

    registrar.addMethodCallDelegate(
      instance,
      channel: channel
    )
  }

  public func handle(
  _ call: FlutterMethodCall,
  result: @escaping FlutterResult
  ) {

    self.flutterResult = result

    switch call.method {

    case "initialize":
      initializeSDK(arguments: call.arguments)
      result(true)

    case "startPayment":
      startPayment(arguments: call.arguments, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Initialize SDK

  private func initializeSDK(arguments: Any?) {

    guard let args = arguments as? [String: Any] else {
      return
    }

    let themeMap = args["theme"] as? [String: Any]

    let theme = createTheme(from: themeMap)

    let config = SDKConfiguration(
      terminalId: args["terminalId"] as? String ?? "",
      password: args["password"] as? String ?? "",
      merchantKey: args["merchantKey"] as? String ?? "",
      baseURL: args["baseUrl"] as? String ?? "",
      theme: theme
    )

    print("========== SDK Configuration ==========")
    print("Terminal ID : \(config.terminalId)")
    print("Base URL    : \(config.baseURL)")
    print("MerchantKey : \(config.merchantKey)")
    print("=======================================")

    InAppSDK.shared.initialize(configuration: config)
  }

  // MARK: - Start Payment

  private func startPayment(
  arguments: Any?,
  result: @escaping FlutterResult
  ) {

    guard let args = arguments as? [String: Any] else {
      result(
        FlutterError(
          code: "INVALID_ARGUMENTS",
          message: "Arguments missing",
          details: nil
        )
      )
      return
    }

    let request = PaymentRequestData(
      amount: args["amount"] as? String ?? "",
      transactionType: args["transactionType"] as? String ?? "",
      currency: args["currency"] as? String ?? "",
      email: args["email"] as? String ?? "",
      address: args["address"] as? String ?? "",
      city: args["city"] as? String ?? "",
      state: args["state"] as? String ?? "",
      zip: args["zip"] as? String ?? "",
      countryCode: args["countryCode"] as? String ?? "",
      trackId: args["trackId"] as? String ?? "",
      cardOperation: args["cardOperation"] as? String ?? "",
      cardToken: args["cardToken"] as? String ?? "",
      tokenType: args["tokenType"] as? String ?? "",
      transactionId: args["transactionId"] as? String ?? "",
      metadata: args["metadata"] as? String ?? ""
    )

    InAppSDK.shared.startPayment(request: request) { response in

      DispatchQueue.main.async {
          result(response.amount ?? "") //Raw Response = response.rawjson
      }
    }
  }

  // MARK: - Theme
  private func createTheme(from map: [String: Any]?) -> SDKTheme {

    guard let map = map else {
      return .light
    }

    // MARK: Merchant Branding
    let branding: SDKMerchantBranding

    if let brandingMap = map["merchantBranding"] as? [String: Any] {

      let type = brandingMap["type"] as? String

      if type == "logo",
      let logoName = brandingMap["logo"] as? String {

        if let logo = getFlutterAssetImage(logoName) {
          branding = SDKMerchantBranding.logo(logo)
        } else {
          print("❌ Failed to load Flutter logo: \(logoName)")
          branding = SDKMerchantBranding.none()
        }

      } else if type == "text",
      let text = brandingMap["text"] as? String {

        branding = SDKMerchantBranding.text(text)

      } else {

        branding = SDKMerchantBranding.none()
      }

    } else {

      branding = SDKMerchantBranding.none()
    }

    // Primary Button

    let primaryButtonMap = map["primaryButton"] as? [String: Any]

//    let inputStyleModelMap = map["inputStyleModel"] as? [String: Any]
//    let sdkTextStyleModelMap = map["sdkTextStyleModel"] as? [String: Any]
//
//    // DEBUG
//    print("========== Flutter Theme ==========")
//    print("Theme Map: \(map)")
//    print("Primary Button Map: \(primaryButtonMap ?? [:])")
//    print("Primary Height: \(cgFloat(primaryButtonMap?["height"], defaultValue: 50))")
//
//    print("===================================")

    let primaryButtonStyle = SDKButtonStyle(
      backgroundColor: color(primaryButtonMap?["backgroundColor"]),
      textColor: color(primaryButtonMap?["textColor"]),
      cornerRadius: CGFloat(primaryButtonMap?["cornerRadius"] as? Double ?? 12),
      borderColor: color(primaryButtonMap?["borderColor"]),
      borderWidth: CGFloat(primaryButtonMap?["borderWidth"] as? Double ?? 0),

      height: cgFloat(primaryButtonMap?["height"], defaultValue: 50.0)
    )

    let textStyleMap =
    map["sdkTextStyle"] as? [String: Any]
    let textStyle =
    SDKTextStyle(

      color:
      color(
        textStyleMap?["textColor"]
      ),

      height:
      cgFloat(
        textStyleMap?["textSize"],
        defaultValue: 26
      ),

      isBold:
      textStyleMap?["bold"] as? Bool ?? false
    )
    // MARK: Input Style

    let inputStyleMap =    map["inputStyle"] as? [String: Any]

    let inputStyle =
            SDKInputStyle(
      backgroundColor: color(inputStyleMap?["backgroundColor"]),
      borderColor:
      color(
        inputStyleMap?["borderColor"]
      ),

      borderWidth:
      cgFloat(
        inputStyleMap?["borderWidth"],
        defaultValue: 1
      ),

      cornerRadius:
      cgFloat(
        inputStyleMap?["cornerRadius"],
        defaultValue: 12
      )
    )





    return SDKTheme (
      primaryColor: color(map["primaryColor"]),
      merchantBranding: branding,
      backgroundColor: color(map["backgroundColor"]),
      primaryButtonStyle: primaryButtonStyle,
      labelStyle: textStyle,
      inputStyle: inputStyle
    )
  }

  // MARK: - Flutter Asset Loader

  private func getFlutterAssetImage(_ assetName: String) -> UIImage? {

    guard let registrar = registrar else {
      print("❌ Flutter registrar is not available")
      return nil
    }

    let key = registrar.lookupKey(forAsset: assetName)

    print("========== Flutter Asset ==========")
    print("Asset Name : \(assetName)")
    print("Asset Key  : \(key)")
    print("===================================")

    guard let image = UIImage(named: key) else {
      print("❌ UIImage could not load asset: \(key)")
      return nil
    }

    print("✅ Flutter asset loaded successfully")

    return image
  }
  private func color(_ value: Any?) -> Color {

    guard let hex = value as? String else {
      return .clear
    }

    return Color(uiColor: UIColor(hex: hex))
  }


  private func cgFloat(_ value: Any?, defaultValue: CGFloat) -> CGFloat {

    if let value = value as? CGFloat {
      return value
    }

    if let value = value as? Double {
      return CGFloat(value)
    }

    if let value = value as? Float {
      return CGFloat(value)
    }

    if let value = value as? Int {
      return CGFloat(value)
    }

    if let value = value as? NSNumber {
      return CGFloat(truncating: value)
    }

    return defaultValue
  }
}

// MARK: - UIColor Extension

extension UIColor {

  convenience init(hex: String) {

    var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)

    hex = hex.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    Scanner(string: hex).scanHexInt64(&rgb)

    self.init(
      red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
      green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
      blue: CGFloat(rgb & 0xFF) / 255.0,
      alpha: 1.0
    )
  }
}
