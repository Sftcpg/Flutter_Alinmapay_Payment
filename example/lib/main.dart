import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_alinmapay_payment/flutter_alinmapay_payment.dart';
import 'package:flutter_alinmapay_payment_example/payment_page.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaymentPage(),
    );
  }
}