import 'package:flutter/material.dart';
import 'ui_items/orderedProductCard.dart';
import 'ordersScreen.dart';

class Product {
  int id;
  String imageUrl;
  String name;
  double price;
  int time;

  Product(this.id, this.imageUrl, this.name, this.price, this.time);
  String getImage() {
    return imageUrl;
  }

  String getName() {
    return name;
  }

  double getPrice() {
    return price;
  }
}

// Order class
class Order {
  // order ID should be some thing like this
  // O3UKG6
  // I guess
  String orderID;
  String orderCode;
  // list of products in the order
  List<Product> products = new List<Product>();

  // constructor
  Order(this.orderID, this.orderCode);

  Duration getMaxDuration() {
    int time = 0;
    for (var product in products) {
      if (product.time > time) time = product.time;
    }
    return Duration(minutes: time);
  }

  // returns total price for order
  double getTotal() {
    double total = 0;
    for (var prod in products) {
      total += prod.price;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  // returns all the products in the order
  // as OrderedProductCard list
  List<Widget> getWidgets(OrdersScreenState s) {
    List<Widget> a = new List<Widget>();
    int count = 100;
    for (var p in products) {
      var w = new OrderedProductCard(p, count, s);
      a.add(w);
      count++;
    }
    a.add(Container(
      height: 500,
      padding: EdgeInsets.only(bottom: 200),
      child: Center(
        child: Text(
          orderCode,
          style: TextStyle(
              color: Colors.black, fontSize: 128, fontFamily: "Oswald"),
        ),
      ),
    ));
    return a;
  }

  // adds a product to the order
  void addProduct(Product p) {
    products.add(p);
  }
}
