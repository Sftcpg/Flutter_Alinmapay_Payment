import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_alinmapay_payment_platform_interface.dart';

/// An implementation of [FlutterAlinmapayPaymentPlatform] that uses method channels.
class MethodChannelFlutterAlinmapayPayment extends FlutterAlinmapayPaymentPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_alinmapay_payment');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
