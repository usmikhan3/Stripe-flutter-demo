import 'package:flutter/material.dart';
import 'package:stripe_integration/screens/home/home_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   Stripe.publishableKey = 'pk_test_51I6GQoHHuBwYnmJfBVMV051hKKS8YgsdckJncc2ZrOC3bKROBn2aXLW0J1sxSX7ko9UUFpcjTBdPuNZTZTs9Wg2900hwQElEc0';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stripe',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

