import 'package:flutter/material.dart';
import 'loading.dart';
import 'ordersScreen.dart';
import 'splash.dart';
import 'paymentScreen.dart';
import 'mainScreen.dart';

// Starting flutter
void main() => runApp(MyApp());

// Setting up base values for the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title, obsolete
      title: 'Stones',

      // setting up themes for the app
      theme: ThemeData(
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 32.0,
            color: Colors.black,
            fontFamily: 'Oswald'
            ),
          headline: TextStyle(
            fontSize: 26.0,
            color: Colors.black,
            fontFamily: 'Oswald'
          ),
          subtitle: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontFamily: 'Leto'
          ),
          body1: TextStyle(
            fontSize: 18.0,
            color: Colors.black,
            fontFamily: 'Leto'
          )
        )
      ),

      // setting up navigation routes
      routes:
      {
        '/main': (context) => MainScreen(),
        'splash': (context) => SplashScreen(),
        '/orders': (context) => OrdersScreen(),
        '/pay': (context) => PaymentScreen(),
        '/loading': (context) => LoadingScreen()
      },

      // setting splash as the starting screen
      home: SplashScreen()
    );
  }
}
