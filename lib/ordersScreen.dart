import 'package:flutter/material.dart';
import 'package:stonesorders/functions.dart';
import 'order.dart';
import 'paymentScreen.dart';
import 'localdb.dart';
import 'ui_items/orderCard.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';

// OrdersScreen class implements a Stateless Widgets,
// which is used to display items that is already ordered
class OrdersScreen extends StatefulWidget {
  String order = "all";

  OrdersScreen.notification(this.order);
  OrdersScreen();
  @override
  OrdersScreenState createState() => OrdersScreenState(order);
}

class OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  String order = "";
  OrdersScreenState(this.order);
  List<Widget> widgets;
  List<Widget> slide;
  BottomBarController bbc;
  bool slideUp = false;

  //navigationBar
  void navBarTapped(int index) {
    print("bottombar_button_pressed_index: " + index.toString());
    if (index == 0) {
      Functions.setUiColors(Color(0xFFC9D6B8), false);
      Navigator.of(context).pop();
    }
  }

//Display items and implements notification
  @override
  void initState() {
    super.initState();
    bbc = BottomBarController(vsync: this, snap: true, dragLength: 500);
    if (LocalDB.orders.length == 0) {
      slide = new List<Widget>();
      slide.add(Center(child: Text("Empty")));
    } else {
      slide = LocalDB.orders[0].getWidgets(this);
    }
  }

  void genWidgets() {
    widgets = new List();
    if (/*!PaymentScreenState.success()*/LocalDB.orders.length < 1) {
      widgets.add(Container(
          height: 500.0,
          alignment: Alignment.center,
          child: Text(
            'Empty',
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Color(0xFF857B78)),
          )));
    } else {
      int count = 0;
      for (var order in LocalDB.orders) {
        widgets.add(OrderCard(order, this, count));
        count++;
      }
    }
    widgets = widgets.reversed.toList();
  }

  Widget slideWidgets() {
    return ListView(children: slide);
  }

  void openSlide(Order o) {
    setState(() {
      slide = o.getWidgets(this);
      slideUp = true;
    });
    bbc.open();
  }

  void closeSlide() {
    bbc.close();
    setState(() {
      slideUp = false;
    });
  }

  void goBack() {
    LocalDB.save();
    Functions.setUiColors(Color(0xFFC9D6B8), false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    //notification if the payment is successful
    if(PaymentScreenState.notification)
      {
        Functions.showNotification(LocalDB.orders.last.getMaxDuration());
        PaymentScreenState.notification = false;
      }
    genWidgets();
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        child: Icon(Icons.arrow_back),
        onPressed: () => {
              if (slideUp) {closeSlide()} else {goBack()}
            },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(
        title: Hero(
          tag: 'title',
          child: Text(
            'Orders',
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF838c77),
        elevation: 16.0,
        leading: Container(),
      ),
      body: Functions.blurOnStatement(
          ListView(
            children: widgets,
          ),
          slideUp),
      bottomNavigationBar: BottomExpandableAppBar(
        controller: bbc,
        expandedHeight: 500.0,
        horizontalMargin: 32,
        appBarHeight: 60,
        shape: CircularNotchedRectangle(),
        expandedDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 8.0, spreadRadius: 2.0)
            ]),
        expandedBody: Center(
          child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: slideWidgets() != null ? slideWidgets() : Text("Empty")),
        ),
        bottomAppBarBody: Hero(
          tag: "bar",
          child: BottomNavigationBar(
            backgroundColor: Color(0xFF838c77),
            elevation: 12.0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white30,
            currentIndex: 1,
            onTap: navBarTapped,
            items: [
              BottomNavigationBarItem(
                title: Text('Menu'),
                icon: Icon(Icons.fastfood),
              ),
              BottomNavigationBarItem(
                title: Text('Orders'),
                icon: Icon(Icons.receipt),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
