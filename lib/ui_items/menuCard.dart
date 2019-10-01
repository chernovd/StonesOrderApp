import 'package:flutter/material.dart';
import '../order.dart';
import '../localdb.dart';

// MenuCard class implements a Stateless Widgets,
// which is used to display information about
// a certain menu item. E.g: Toast
class MenuCard extends StatelessWidget {
  final int productID; // ID of the product
  final String imageUrl; // URL of the image of the product
  final String name; // Name of the product
  final String special; // Any special requests, allergies, etc.
  final String category; // Category of product
  final double price; // Price of the product
  final int time;

  // Contructor to initialize the fields
  MenuCard(this.productID, this.imageUrl, this.name, this.price, this.special,
      this.category, this.time);

  // build method
  // this method generates the Widget
  // that we are going to use
  @override
  Widget build(BuildContext context) {
    // Creating the SnackBar element
    // to be shown if the user taps
    // on this Card
    final snackbar = SnackBar(
      content: Text('$name has been added to your cart.'),
      duration: Duration(milliseconds: 500),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          LocalDB.orders.removeLast();
        },
      ),
    );

    // Creating SnackBar in case,
    // the user has reach the limit
    final snackbar2 = SnackBar(
      content: Text('You reached the limit'),
      duration: Duration(seconds: 1),
    );

    // Creating the Widget system
    // to be used as MenuCard
    return Card(
      // Using the built in Card as a foundation
      elevation: 6.0, // Material design, elevation
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

      // 'semanticContainer' field makes sure,
      // that the image doesn't overflow
      // the parent Widget
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer, // anti alias, because we can
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(8.0), // setting the card border radius
      ),
      child: GestureDetector(
        // Handles user interaction (tap, swipe, etc...)
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity, // flutter trick, it's not that wide irl
              height: 180.0,
              child: FadeInImage.assetNetwork(
                // Loads the image from network
                image: imageUrl, // image of product
                placeholder: 'assets/images/load.gif', // placeholder .gif
                fit: BoxFit.cover,
              ),
            ),
            Divider( // this is a really tiny divider
              height: 0.0, // so tiny you might not see it
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    name, // name of the product
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline,
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    '€$price', // price of the product
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.headline,
                  )
                ],
              ),
            )
          ],
        ),

        // This is one of the input
        // handlers from GestureDetector
        // runs the following anonymous function
        onTap: () {
          if (LocalDB.size() < 3) { // checks if there's already 3 products in the basket
            // adds the product to the basket
            LocalDB.products.add(new Product(productID, imageUrl, name, price, time));
            Scaffold.of(context).showSnackBar(snackbar);
          } else {
            // shows error SnackBar
            Scaffold.of(context).showSnackBar(snackbar2);
          }
        },
      ),
    );
  }
}
