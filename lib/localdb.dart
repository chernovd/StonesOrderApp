import 'order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  static List<Product> products;
  static List<Order> orders;
  static const bool MEME = false;
  static bool loading = false;
  static int size() {
    return products.length;
  }

// Total price of all added items to the basketCard
  static double getTotal() {
    double pay = 0;
    for (var order in products) {
      pay += order.price;
    }
    return double.parse(pay.toStringAsFixed(2));
  }

  static List<String> getOrders() {
    List<String> result = new List<String>();
    for (var o in orders) {
      String tmp = "";
      tmp += o.orderID + "-+-";
      tmp += o.orderCode + "|||";
      for (var p in o.products) {
        tmp += p.id.toString() + ":::";
        tmp += p.name.toString() + ":::";
        tmp += p.imageUrl.toString() + ":::";
        tmp += p.price.toString() + ":::";
        tmp += p.time.toString() + "|||";
      }
      result.add(tmp);
    }
    return result;
  }

  static void save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "products";
    final value = getOrders();
    prefs.setStringList(key, value);
  }

  static void load() async {
    final prefs = await SharedPreferences.getInstance();
    final key = "products";
    final value = prefs.getStringList(key);
    print(value);

    List<Order> od = new List<Order>();
    for (var o in value) {
      Order order = new Order("temp", "temp");
      print("id received: " + o.split("-+-")[0]);
      order.orderID = o.split("-+-")[0];

      print("code received: " + o.split("-+-")[1].split("|||")[0]);
      order.orderCode = o.split("-+-")[1].split("|||")[0];
      bool first = true;
      for (var prod in o.split("|||")) {
        if (prod.length < 1) break;
        if (first) {
          first = false;
          continue;
        }

        var parts = prod.split(":::");
        int id = int.parse(parts[0]);
        print("id: " + id.toString());
        String name = parts[1];
        print("name: " + name);
        String image = parts[2];
        print("image: " + image);
        double price = double.parse(parts[3]);
        print("price: " + price.toStringAsFixed(2));
        int time = int.parse(parts[4]);

        var product = new Product(id, image, name, price, time);
        order.addProduct(product);
      }
      od.add(order);
    }
    orders = od;
  }
}
