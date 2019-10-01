import 'package:flutter/material.dart';
import 'functions.dart';
import 'localdb.dart';

class PaymentScreen extends StatefulWidget {
  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  bool _value1 = false;
  static bool payment = false;
  static bool notification =false;
  void _value1Changed(bool value) => setState(() => _value1 = value);

  List<DropdownMenuItem<String>> listDrop = [];
  String selected = 'ING';
  void loadData() {
    listDrop = [];
    listDrop.add(new DropdownMenuItem(
      child: new Text('ING'),
      value: 'ING',
    ));
    listDrop.add(new DropdownMenuItem(
      child: new Text('Rabobank'),
      value: 'Rabobank',
    ));
    listDrop.add(new DropdownMenuItem(
      child: new Text('ABN'),
      value: 'ABN',
    ));
  }
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    loadData();
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8,left:8),
                  child: Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: _value1,
                  onChanged: _value1Changed,
                  title: Text('iDEAL'),
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: Image.asset(
                    'images/ideal.gif',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(padding: const EdgeInsets.only(left:26),
                    child: DropdownButton(

                        value: selected,
                        items: listDrop,
                        hint: Text('Select bank'),
                        onChanged: (value) {
                          selected = value;
                          setState(() {});
                  },
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget paytotal = Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Hero(
        tag: 'card',
        child: RaisedButton(
          padding: EdgeInsets.all(16.0),
          color: Color(0xFFAA7B47),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(
            'Pay: €${LocalDB.getTotal()}',
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(color: Colors.white),
          ),
          onPressed: () async {

            if (_value1 && selected != null) {
              LocalDB.loading = true;
              Functions.createOrder();
              Navigator.of(context).pushReplacementNamed('/loading');
            }
          },
        ),
      ),
    );

    void goBack() {
      Functions.setUiColors(Color(0xFFC9D6B8), false);
      Navigator.of(context).pop();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "fab",
        child: Icon(Icons.arrow_back),
        onPressed: () => goBack(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(
        title: Hero(
          tag: 'title',
          child: Text(
            'Payment',
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFAA7B47),
        elevation: 16.0,
        leading: Container(),
      ),
      body: ListView(
        children: [titleSection, paytotal],
      ),
    );
  }

  static bool success() {
    return payment;
  }

}
