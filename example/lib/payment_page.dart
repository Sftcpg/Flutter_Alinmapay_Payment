import 'package:flutter/material.dart';
import 'package:flutter_alinmapay_payment/model/sdk_merchant_branding.dart';
import 'package:flutter_alinmapay_payment/model/input_style_model.dart';
import 'package:flutter_alinmapay_payment/model/sdk_textstyle_model.dart';
import 'package:flutter_alinmapay_payment/flutter_alinmapay_payment.dart';
import 'package:flutter_alinmapay_payment/model/button_style_model.dart';
import 'package:flutter_alinmapay_payment/model/payment_theme.dart';
import 'package:flutter_alinmapay_payment/model/sdk_configuration.dart';

class TransactionType {
  final String name;            // Display in dropdown
  final String transactionType; // API transactionType
  final String cardOperation;   // API cardOperation

  TransactionType(
      this.name,
      this.transactionType,
      this.cardOperation,
      );
}
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() =>
      _PaymentPageState();
}

class _PaymentPageState
    extends State<PaymentPage> {

  String result = "";

  String _cardOper='Purchase';
  // To show Selected Item in Text.
  String holder = '' ;
  String actionholder = '1' ;
  String cardOperholder = '' ;


  final List<TransactionType> transactionTypes = [
    TransactionType("Purchase", "1", ""),
    TransactionType("PreAuth", "4", ""),
    TransactionType("Tokenization Add", "12", "A"),
    TransactionType("Tokenization Update", "12", "U"),
    TransactionType("Tokenization Delete", "12", "D"),
    TransactionType("Transaction Enquiry", "10", ""),
  ];
  TransactionType? _selectedTransactionType;
  String? _selectedCardOperation;
  final TextEditingController _amountController =  TextEditingController(text: "1.00");

  final TextEditingController _currencyController =  TextEditingController(text: "SAR");

  final TextEditingController _trackIdController =  TextEditingController(text: "1233");

  final TextEditingController _metadataController =  TextEditingController();
  final TextEditingController _trxnIdController =  TextEditingController();
  final TextEditingController _cardTokenController =  TextEditingController();

  @override
  void initState() {
    super.initState();

    initializeSDK();

    // Default selected value
    _selectedTransactionType = transactionTypes.first;
    // _selectedCardOperation = _cardOperList.first;

  }
  @override
  void dispose() {
    _amountController.dispose();
    _currencyController.dispose();
    _trackIdController.dispose();
    _metadataController.dispose();
    _trxnIdController.dispose();
    _cardTokenController.dispose();
    super.dispose();
  }

  // final theme = PaymentTheme(
  //   primaryButton: ButtonStyleModel(
  //     backgroundColor: 0xFFCA6C4E,
  //     textColor: 0xFFFFFFFF,
  //     borderColor: 0xFFCA6C4E,
  //     cornerRadius: 10,
  //   ),
  //   secondaryButton: ButtonStyleModel(
  //     backgroundColor: 0xFFFFFFFF,
  //     textColor: 0xFFCA6C4E,
  //     borderColor: 0xFFCA6C4E,
  //     cornerRadius: 10,
  //   ),
  // );
  //
  // final configuration = SDKConfiguration(
  //   environment: "TEST",
  //   terminalId: "AMRouting",
  //   password: "Password@123",
  //   theme: theme,
  // );

  Future<void> initializeSDK() async {
    const String ass = "assets/concerto.png";
   final theme = PaymentTheme(primaryColor : "#3a527a",
       backgroundColor: "#b0866d",
         primaryButton: ButtonStyleModel(
           backgroundColor: "#3a527a",
           textColor: "#FFFFFF",
           borderColor: "#3a527a",
           borderWidth: 1,
           cornerRadius: 10,
           height: 35,
         ),
         inputStyleModel: InputStyleModel(
           backgroundColor: "#FFFFFF",
           borderColor: "#000000",
           borderWidth: 1.0,
           cornerRadius: 8.0,
         ),
         sdkTextStyleModel: SDKTextStyleModel(
           textSize: 16,
           bold: true,
           textColor: "#000000",
         ),
       //merchantBranding: SDKMerchantBranding.text("Runali's Store"));
     merchantBranding: SDKMerchantBranding.logo(ass));


  //  PaymentTheme(
  //   primaryColor: "#e2f140",
  //
  //   primaryButton: ButtonStyleModel(
  //     backgroundColor: "#b37e2e",
  //     textColor: "#FFFFFF",
  //     borderColor: "#80ca4e",
  //     borderWidth: 1,
  //     cornerRadius: 10,
  //     height: 35,
  //   ),
  //   inputStyleModel: InputStyleModel(
  //     backgroundColor: "#FFFFFF",
  //     borderColor: "#CCCCCC",
  //     borderWidth: 1.0,
  //     cornerRadius: 8.0,
  //   ),
  //
  //   sdkTextStyleModel: SDKTextStyleModel(
  //     textSize: 16,
  //     bold: true,
  //     textColor: "#000000",
  //   ),
  //
  //
  //
  // );

    final configuration = SDKConfiguration(

      terminalId: "Routing",
      password: "Password@123",

      theme: theme,
      baseUrl: 'http://192.168.81.86:8080/CORE_2.2.2',
      merchantKey: 'd49406528388682669387b3bad6883571fc5b14e15c94416e21c94a201543ad9',
    );

    await FlutterAlinmapayPayment.initialize(configuration);
  }
  Future<void> startPayment() async {
    final response =
    await FlutterAlinmapayPayment.startPayment({
      "amount": _amountController.text,
      "transactionType": _selectedTransactionType?.transactionType ?? "",
      "currency": _currencyController.text,
      "trackId": _trackIdController.text,
      "email": "test@test.com",
      "address": "Mumbai",
      "city": "Mumbai",
      "state": "MH",
      "zip": "210210",
      "countryCode": "SA",
      "cardOperation": _selectedTransactionType?.cardOperation ?? "",
      "cardToken": _cardTokenController.text,
      "tokenType": "0",
      "transactionId": _trxnIdController.text,
      "metadata": _metadataController.text
    });

    setState(() {
      result = response.toString();
    });
  }

  void getDropDownItem(String dataHolder){

    setState(() {
      holder = dataHolder ;
      print('HOLDER $holder');
      if(holder=='Purchase')
      {
        actionholder='1';
        cardOperholder='';

      }
      else if(holder=='PreAuth')
      {
        actionholder='4';
        cardOperholder='';
      }
      else if(holder=='Tokenization Add')
      {
        actionholder='12';
        cardOperholder='A';
      }
      else if(holder=='Tokenization Update')
      {
        actionholder='12';
        cardOperholder='U';
      }
      else if(holder=='Tokenization Delete')
      {
        actionholder='12';
        cardOperholder='D';
      }


      else if(holder=='Transaction Enquiry')
      {
        actionholder='10';
        cardOperholder='';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment SDK Demo"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<TransactionType>(
              value: _selectedTransactionType,
              decoration: const InputDecoration(
                labelText: "Card Operation",
                border: OutlineInputBorder(),
              ),
              items: transactionTypes.map((item) {
                return DropdownMenuItem<TransactionType>(
                  value: item,
                  child: Text(item.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTransactionType = value;
                });
              },
            ),

            const SizedBox(height: 15),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),
            TextFormField(
              controller: _trxnIdController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Transaction ID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _currencyController,
              decoration: const InputDecoration(
                labelText: "Currency",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              controller: _trackIdController,
              decoration: const InputDecoration(
                labelText: "Track ID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),
            TextFormField(
              controller: _cardTokenController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Card Token",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),
            TextFormField(
              controller: _metadataController,
              decoration: const InputDecoration(
                labelText: "Metadata",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: startPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB37E2E), // primaryButton.backgroundColor
                foregroundColor: Colors.white,            // primaryButton.textColor
                minimumSize: const Size(double.infinity, 35),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color(0xFF973232),             // primaryButton.borderColor
                    width: 1,
                  ),
                ),
              ),
              child: const Text(
                "Start Payment",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(result),
            ),
          ],
        ),
      ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title:
  //       const Text("Payment SDK Demo"),
  //     ),
  //   body: Padding(
  //   padding: const EdgeInsets.all(20),
  //   child: Column(
  //   crossAxisAlignment: CrossAxisAlignment.stretch,
  //   children: [
  //
  //   DropdownButtonFormField<String>(
  //   value: _selectedCardOperation,
  //   decoration: const InputDecoration(
  //   labelText: "Card Operation",
  //   border: OutlineInputBorder(),
  //   ),
  //   items: _cardOperList.map((String value) {
  //   return DropdownMenuItem<String>(
  //   value: value,
  //   child: Text(value),
  //   );
  //   }).toList(),
  //   onChanged: (String? value) {
  //   setState(() {
  //   _selectedCardOperation = value;
  //   });
  //   },
  //   ),
  //
  //   const SizedBox(height: 20),
  //
  //   ElevatedButton(
  //   onPressed: startPayment,
  //   child: const Text("Start Payment"),
  //   ),
  //
  //   const SizedBox(height: 20),
  //
  //   Expanded(
  //   child: SingleChildScrollView(
  //   child: Text(result),
  //   ),
  //   ),
  //   ],
  //   ),
  //   ),
  //   );
  // }
}