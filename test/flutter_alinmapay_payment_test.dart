import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_alinmapay_payment/flutter_alinmapay_payment_platform_interface.dart';
import 'package:flutter_alinmapay_payment/flutter_alinmapay_payment_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAlinmapayPaymentPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAlinmapayPaymentPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAlinmapayPaymentPlatform initialPlatform = FlutterAlinmapayPaymentPlatform.instance;

  test('$MethodChannelFlutterAlinmapayPayment is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAlinmapayPayment>());
  });
}
