import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 8.0),
      children: <Widget>[
        DrawerHeader(
          child: Text('Settings',
    style:
      Theme.of(context).textTheme.title,
    ),
        ),
        ListTile(title: Text('Language EN/DU'),),

      ],
    );
  }
}