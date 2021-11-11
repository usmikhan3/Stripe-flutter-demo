import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  Map<String,dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stripe Payment"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              InkWell(
                onTap: () async{
                  await makePayment();
                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: 200,
                    decoration:const BoxDecoration(
                      color: Colors.green
                    ),
                    child:const Center(
                      child:
                      Text("PAY"),
                    ),
                  ),
                ),
              )
        ],
      ),
    );
  }

  // Future<void> makePayment() async{
  //   try{
  //     paymentIntentData = await createPaymentIntent('20','USD');
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters:SetupPaymentSheetParameters(
  //             paymentIntentClientSecret: paymentIntentData!['client_secret'],
  //             applePay: true,
  //           googlePay: true,
  //           style: ThemeMode.system,
  //           merchantCountryCode: 'US',
  //           merchantDisplayName: 'USMAN'
  //         ),
  //     );
  //     displayPaymentSheet();
  //   }catch(e){print(e.toString());}
  // }



  Future<void> makePayment() async{
    try{
      paymentIntentData = await createPaymentIntent('20','USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters:SetupPaymentSheetParameters(

            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            applePay: true,
            googlePay: true,
            style: ThemeMode.system,
            merchantCountryCode: 'US',
            merchantDisplayName: 'USMAN'
        ),
      );
      displayPaymentSheet();
    }catch(e){print(e.toString());}
  }


  displayPaymentSheet() async{
     try{
     await  Stripe.instance.presentPaymentSheet(

         parameters: PresentPaymentSheetParameters(clientSecret: paymentIntentData!['client_secret'],
           confirmPayment: true
         )
       );
       setState(() {
         paymentIntentData = null;
       });
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction Successful')));
     }on StripeException catch(e){
       print(e.toString());

       showDialog(context: context, builder: (_)=>const AlertDialog(
         content: Text("Cancelled"),
       ));
     }
  }

  createPaymentIntent(String amount,String currency) async{
    try{
      Map<String,dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'

      };

      var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: body,
        headers: {
        'Authorization': 'Bearer sk_test_51I6GQoHHuBwYnmJflkt48CuIdTDHLviViOPVQ6OLxWHfkcqMlbOuqDnc9YxpvTDjEABq37xJBLaUIQ7uIKKOVsvq00QoPFYeyr',
          'Content-type':'application/x-www-form-urlencoded'
        }
      );
      return jsonDecode(response.body.toString());
    }catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction Failed')));
    }
  }


  calculateAmount(String amount){
    final price = int.parse(amount) * 100;
    return price.toString();
  }

}
