
import 'package:flutter/services.dart';

import 'model/sdk_configuration.dart';

class FlutterAlinmapayPayment {

  static const _channel = MethodChannel(
    'flutter_alinmapay_payment',
  );


// static Future<void> initialize(
// Map<String, dynamic> config) asyn
//
// await _channel.invokeMethod(
// 'initialize',
// config,
// );
// }

  static Future<void> initialize(
      SDKConfiguration configuration,
      ) async {
    await _channel.invokeMethod(
      'initialize',
      configuration.toMap(),
    );
  }

static Future<String?> startPayment(
Map<String, dynamic> request) async {

return await _channel.invokeMethod(
'startPayment',
request,
);
}
}