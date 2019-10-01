import 'dart:async';
import 'functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'localdb.dart';
import 'ui_items/basketCard.dart';
import 'ui_items/customAppBar.dart';

// MainScreen class implements a Stateless Widgets,
// which is used to display a list of menu item.
class MainScreen extends StatefulWidget {
  List<Widget> widgets = new List();
  MainScreen.widget(this.widgets);
  MainScreen();

  @override
  MainScreenState createState() => MainScreenState(widgets);
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<Widget> widgets;
  List<Widget> basketWidgets = new List<Widget>();
  int _index = 0;
  bool slideUp = false;

  Future<void> getConnection(BuildContext context) async {
    var w = await Functions.getCards();
    setState(() {
      widgets = w;
    });
  }

  MainScreenState(this.widgets) {
    if (widgets.length < 1) init();
  }

  BottomBarController bbc;

  void bbcSwap() {
    setState(() {
      bbc.swap();
      genWidgets();
      slideUp = !slideUp;
    });
  }

  void init() async {
    var w = await Functions.getCards();
    setState(() {
      widgets = w;
    });
  }

  Future onSelectNotification(String payload) async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: const Text("Here is your payload"),
              content: new Text("Payload:$payload"),
            ));
  }

  void genWidgets() {
    basketWidgets = new List();
    if (LocalDB.products.length < 1) {
      basketWidgets.add(Container(
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
      for (var product in LocalDB.products) {
        basketWidgets.add(BasketCard(product, count, this));
        count++;
      }
      basketWidgets.add(
        Hero(
          tag: 'card$count',
          child: Container(
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.all(4.0),
            child: RaisedButton(
              padding: EdgeInsets.all(24.0),
              color: Color(0xFF838c77),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                'Total: €${LocalDB.getTotal()}',
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                bbcSwap();
                Functions.setUiColors(Color(0xFFAA7B47), true);
                Navigator.of(context).pushNamed("/pay");
              },
            ),
          ),
        ),
      );
      basketWidgets.add(Container(
        height: 70.0,
      ));
    }
  }

  Widget getBasket() {
    if (basketWidgets.length == 0)
      return Center(
        child: Text("Basket is empty."),
      );
    else
      return ListView(children: basketWidgets);
  }

  @override
  void initState() {
    super.initState();
    print("init main screen");
    bbc = BottomBarController(vsync: this, dragLength: 500.0, snap: true);
  }

  void navBarTapped(int index) {
    print("bottombar_button_pressed_index: " + index.toString());
    if (index == 1) {
      Functions.setUiColors(Color(0xFF838c77), true);
      Navigator.of(context).pushNamed("/orders");
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
          child: FloatingActionButton(
            heroTag: "fab",
            backgroundColor: Color(0xFFC9D6B8),
            foregroundColor: Colors.black,
            child: Icon(Icons.shopping_basket),
            elevation: 6,
            onPressed: bbcSwap,
          ),
        ),
        //drawer: Drawer(child: DrawerItems()),
        body: Stack(children: [
          Container(
            padding: EdgeInsets.only(top: 64),
            decoration: BoxDecoration(color: Color(0xFFC9D6B8)),
            child: RefreshIndicator(
              onRefresh: () {
                return getConnection(context);
              },
              child: Functions.blurOnStatement(
                  ListView(
                    children: widgets,
                    physics: AlwaysScrollableScrollPhysics(),
                  ),
                  slideUp),
            ),
          ),
          CustomAppBar(_scaffoldKey),
        ]),
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
              child: getBasket(),
            ),
          ),
          bottomAppBarBody: Hero(
            tag: "bar",
            child: BottomNavigationBar(
              backgroundColor: Color(0xFFC9D6B8),
              elevation: 12.0,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black38,
              currentIndex: _index,
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
        ));
  }
}
