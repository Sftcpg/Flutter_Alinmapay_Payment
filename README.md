# flutter_alinmapay_payment

Official Flutter plugin for Alinma Pay Payment SDK integration. This plugin allows you to integrate secure payment processing into your Flutter applications using Alinma Pay's native SDKs for Android and iOS.

## Features

- **Easy Integration:** Seamlessly connect to Alinma Pay's payment gateway.
- **Customizable UI:** Full support for theme customization including colors, button styles, text styles, and input styles.
- **Merchant Branding:** Display your merchant logo or name in the payment interface.
- **Multiple Transaction Types:** Support for Purchase, PreAuth, Tokenization, and more.

## Getting Started

### Installation

Add `flutter_alinmapay_payment` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_alinmapay_payment: ^2.0.0
```

### Android Setup

Ensure your `minSdkVersion` is at least 21 in `android/app/build.gradle`.

### iOS Setup

Ensure your deployment target is at least 15.6.

## Usage

```dart
import 'package:flutter_alinmapay_payment/flutter_alinmapay_payment.dart';

// Initialize the SDK
final configuration = SDKConfiguration(
  terminalId: "your_terminal_id",
  password: "your_password",
  merchantKey: "your_merchant_key",
  baseUrl: "your_base_url",
  theme: PaymentTheme(...),
);

await FlutterAlinmapayPayment.initialize(configuration);

// Start a payment
final response = await FlutterAlinmapayPayment.startPayment({
  "amount": "10.00",
  "currency": "SAR",
  // ... other parameters
});
```

For more details, see the example app.
