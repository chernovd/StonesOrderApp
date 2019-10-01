import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../localdb.dart';
import '../order.dart';
import '../ordersScreen.dart';

// This class implements a Card
// for viewing the basic information
// about an order (code, price, etc...)
class OrderCard extends StatelessWidget {
  final Order order; // the order we need to display info about

  // This is an instance of the OrderScreen
  // we need to trigger the bottom slider
  // to display detailed info about the order
  // when we tap on it
  final OrdersScreenState state;
  final int hero;
  // contructor
  OrderCard(this.order, this.state, this.hero);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector detecting
      // using the instance to open the bottom slider
      onTap: () {
        state.openSlide(order);
      },
      onLongPress: () {
        state.setState(() {
          LocalDB.orders.remove(order);
        });
      },
      child: Hero(
        tag: "card" + hero.toString(),
        child: Card(
          // using Card as base
          elevation: 3.0,
          semanticContainer: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    // shows image of first product
                    image: NetworkImage(order.products[0].imageUrl),
                    fit: BoxFit.cover,
                    // puts white overlay onto the image
                    colorFilter: ColorFilter.mode(
                        Color(0x0AFFFFFF), BlendMode.dstATop))),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    order.orderCode, // shows the orderID
                    style: Theme.of(context)
                        .textTheme
                        .headline
                        .copyWith(color: Colors.black45),
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '€${order.getTotal()}',
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
