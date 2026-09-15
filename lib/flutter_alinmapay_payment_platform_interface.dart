import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_alinmapay_payment_method_channel.dart';

abstract class FlutterAlinmapayPaymentPlatform extends PlatformInterface {
  /// Constructs a FlutterAlinmapayPaymentPlatform.
  FlutterAlinmapayPaymentPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAlinmapayPaymentPlatform _instance = MethodChannelFlutterAlinmapayPayment();

  /// The default instance of [FlutterAlinmapayPaymentPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAlinmapayPayment].
  static FlutterAlinmapayPaymentPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAlinmapayPaymentPlatform] when
  /// they register themselves.
  static set instance(FlutterAlinmapayPaymentPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
