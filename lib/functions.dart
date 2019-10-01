import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:http/http.dart' as http;
import 'localdb.dart';
import 'order.dart';
import 'paymentScreen.dart';
import 'ui_items/menuCard.dart';
import 'dart:async';
import 'ordersScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Functions {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static void init() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  //If you click on the notification, the message will pop up
  static Future selectNotification(String payload) async {
    debugPrint("payload : $payload");
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Notification'),
              content: Text('$payload'),
            ));
  }

  //method that creates a notification if the order is done
  static void showNotification(Duration dur) async {
    //dur = Duration(seconds: 30);
    var android = new AndroidNotificationDetails(
        'stones', 'order', 'notification to diplay the food readiness',
        style: AndroidNotificationStyle.BigText,
        priority: Priority.Max,
        autoCancel: false,
        importance: Importance.Max);
    var quiet = new AndroidNotificationDetails(
        'stones', 'order', 'notification to diplay the food readiness',
        style: AndroidNotificationStyle.BigText,
        priority: Priority.Max,
        autoCancel: false,
        ongoing: true,
        importance: Importance.Max);
    var ios = new IOSNotificationDetails(presentAlert: true, presentSound: true);
    var scheduledNotificationDateTime = new DateTime.now().add(dur);
    
    var details = new NotificationDetails(quiet, ios);
    await flutterLocalNotificationsPlugin.show(
        523,
        'Almost ready',
        'Estimated pickup time: '
        + (DateTime.now().add(dur)).hour.toString()
        + ":"
        + (DateTime.now().add(dur)).minute.toString()
        + ".\nYou will be notified when it's ready.\nNotification will be removed, when your order is ready.",
        details,
        payload: 'wait');
    details = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.schedule(
        523,
        'Done',
        'You can pick up your order. Please go to the cafeteria.',
        scheduledNotificationDateTime,
        details,
        payload: 'ready');
    
  }

  // Downloads data of available menu items
  // and parses them into MenuCards
  static Future<List<Widget>> getCards() async {
    String url = ''; // TODO url for connection
    String text = '';
    dynamic response = await http.post(url, body: {'action': 'GET'});
    text = response.body;
    if (text == null) {
      return null;
    }
    var lines = text.split("<||>");
    lines.removeLast();
    List<Widget> wid = new List();
    for (var line in lines) {
      try {
        int id = int.parse(line.split(':::')[0]);
        double price = double.parse(line.split(':::')[1]);
        String name = line.split(':::')[2];
        String special = line.split(':::')[3];
        String category = line.split(':::')[4];
        String url = line.split(':::')[5];
        int time = int.parse(line.split(':::')[6]);
        wid.add(MenuCard(id, url, name, price, special, category, time));
      } catch (e) {
        print(e.toString());
      }
    }
    return wid;
  }

  static Future createOrder() async {
    List<String> o = new List();
    for (var product in LocalDB.products) {
      o.add(product.id.toString());
    }

    String url = ''; // TODO url for connection
    List<String> text = new List();
    dynamic response = await http.post(url, body: {
      'action': 'ORDER',
      'products': o.join(":"),
    });
    print(o.join(":"));
    text = response.body.toString().split(":");
    print("==================================");
    print(text);
    Order order = new Order(text[0], text[1]);
    for (var product in LocalDB.products) {
      order.addProduct(product);
    }
    LocalDB.orders.add(order);
    LocalDB.products.clear();

    LocalDB.loading = false;
    PaymentScreenState.notification = true;
    PaymentScreenState.payment = true;
  }

  static BuildContext context;

  static Future getNoti(BuildContext _context) async {
    context = _context;
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    return null;
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => new OrdersScreen.notification(payload)),
    );
  }

  // Sets the UI color (statusbar, navigationbar),
  // as well as the icons to be black or white
  // Android, iOS compatibility
  static void setUiColors(Color color, bool whiteIcons) {
    FlutterStatusbarcolor.setStatusBarColor(color);
    FlutterStatusbarcolor.setNavigationBarColor(color);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(whiteIcons);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(whiteIcons);
  }

  static Future setUiColorsLater(
      Color color, bool whiteIcons, Duration dur) async {
    await Future.delayed(dur, () {
      FlutterStatusbarcolor.setStatusBarColor(color);
      FlutterStatusbarcolor.setNavigationBarColor(color);
      FlutterStatusbarcolor.setStatusBarWhiteForeground(whiteIcons);
      FlutterStatusbarcolor.setNavigationBarWhiteForeground(whiteIcons);
    });
  }

  // creates a Widget structre in which the
  // provided child Widget (and all it's childs)
  // can be blurred, based on a provided boolean
  // true: blur
  // false: no blur
  static Widget blurOnStatement(Widget child, bool statement) {
    Widget blur = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: LocalDB.MEME ? 2 : 10),
      child: new Container(
        decoration: new BoxDecoration(
            color: LocalDB.MEME
                ? Colors.red.withOpacity(.6)
                : Colors.white.withOpacity(.4)),
      ),
    );

    return Stack(
      children: <Widget>[child, if (statement) blur],
    );
  }
}
