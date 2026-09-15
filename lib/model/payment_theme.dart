import 'package:flutter_alinmapay_payment/model/sdk_merchant_branding.dart';

import 'button_style_model.dart';
import 'input_style_model.dart';
import 'sdk_textstyle_model.dart';

class PaymentTheme {

  final String? primaryColor;
  final String? backgroundColor;
   final ButtonStyleModel? primaryButton;
  final InputStyleModel? inputStyleModel;
  final SDKTextStyleModel? sdkTextStyleModel;
  final SDKMerchantBranding? merchantBranding;
  const PaymentTheme({
    required this.primaryColor,

    required this.backgroundColor,


    required this.primaryButton,

    required this.inputStyleModel,
    required this.sdkTextStyleModel,
    required this.merchantBranding
  }
  );

  Map<String, dynamic> toMap() {
    return {
      
      "primaryColor": primaryColor,
      "backgroundColor": backgroundColor,

      "primaryButton": primaryButton?.toMap(),

      "inputStyle":inputStyleModel?.toMap(),
      "sdkTextStyle":sdkTextStyleModel?.toMap(),
      "merchantBranding": merchantBranding?.toMap(),
    };
  }
}