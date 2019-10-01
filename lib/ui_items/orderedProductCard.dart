import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../order.dart';
import '../ordersScreen.dart';


// Really simple Card to display
// the products in an order
// everything has been described in other classes
class OrderedProductCard extends StatelessWidget {
  final Product product;
  final int hero;
  final OrdersScreenState state;

  OrderedProductCard(this.product, this.hero, this.state);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'card$hero',
      child: Card(
        elevation: 3.0,
        semanticContainer: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.white10, BlendMode.dstATop))),
          child: Container(
            padding: EdgeInsets.all(16.0),
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
                Text(
                  '€${product.price}',
                  style: Theme.of(context).textTheme.body1,
                  overflow: TextOverflow.fade,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
