import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../order.dart';
import '../localdb.dart';
import '../mainScreen.dart';
//// basketCard class implements a Stateless Widgets,
//// which is used to display information about
//// a certain menu item that is added to the basket. E.g: Pasta
class BasketCard extends StatelessWidget {
  final Product product;
  final int hero;
  final MainScreenState state;

   BasketCard(this.product, this.hero, this.state);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'card$hero',
      child: Card(
        elevation: 3.0,
        semanticContainer: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              product.imageUrl
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white10, BlendMode.dstATop)
          )
        ),
          //Container with added items(Name, Price) and the possibility to remove the item
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '€${product.price}',
                      style: Theme.of(context).textTheme.body1,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        // ignore: invalid_use_of_protected_member
                        state.setState(() {
                          LocalDB.products.remove(product);
                          state.genWidgets();
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
