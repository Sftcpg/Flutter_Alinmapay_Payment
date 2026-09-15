import 'payment_theme.dart';

class SDKConfiguration {
  final String baseUrl;
  final String merchantKey;
  final String terminalId;
  final String password;
  final PaymentTheme theme;

  const SDKConfiguration({
    required this.baseUrl,
    required this.merchantKey,
    required this.terminalId,
    required this.password,
    required this.theme,
  });

  Map<String, dynamic> toMap() {
    return {
      "baseUrl": baseUrl,
      "merchantKey": merchantKey,
      "terminalId": terminalId,
      "password": password,
      "theme": theme.toMap(),
    };
  }
}