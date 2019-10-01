import 'package:flutter/material.dart';
import 'functions.dart';
import 'mainScreen.dart';
import 'localdb.dart';

// Splash screen for the app
// Initializes the app, basically
// a loading screen, but better
class SplashScreen extends StatelessWidget {

  // gets all the menu items for the MainScreen
  // initializes LocalDB, sets colors for MainScreen
  // and after it finished it jumps to MainScreen

  // Future runs in the background
  Future<void> getConnection(BuildContext context) async {
      var w = await Functions.getCards();
      Functions.setUiColorsLater(Color(0xFFC9D6B8), false, Duration(seconds: 1));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen.widget(w)));
    }

  @override
  Widget build(BuildContext context) {
    Functions.setUiColors(Color(0xFFDBC7C2), false); // sets ui color to match splash design
    print('building splash'); // debug message, only console can see it
    Functions.init();
    LocalDB.orders = new List();
    LocalDB.products = new List();
    LocalDB.load();
    getConnection(context);

    return Scaffold(
      backgroundColor: Color(0xFFFBE7E2), // background color
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Hero widgets with the same tag,
            // will automatically animate between
            // different pages
            Hero(
              tag: 'logo',
              child: Image( // logo
                image: AssetImage('assets/images/logo_square.png'),
              ),
            ),
            Text( // title
              'Stones Restaurant\nOrders',
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
