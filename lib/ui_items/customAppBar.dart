import 'package:flutter/material.dart';

// ignore: must_be_immutable
// CustomAppBar impements a (guess what)
// We use a custom appBar, because the
// theming had some issues, with the 
// built in Widget
class CustomAppBar extends StatelessWidget {
  
  // The built in AppBar had the functionality
  // to tap on the Stones logo and open
  // a drawer on the left side of the app
  // to keep this functionality we need to
  // get the GLobalKey of the Scaffold Widget
  // and use it to open the drawer
  GlobalKey<ScaffoldState> _scaffoldKey;

  // constructor
  CustomAppBar(this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    // gets statusbar color, to display the AppBar correctly
    double height = MediaQuery.of(context).padding.top;

    // Positioned Widget is basically
    // "position: fixed" in CSS
    // it's pretty cool
    return Positioned(
      top: height,
      left: 0,
      child: Container(
        decoration: BoxDecoration(color: Color(0xFFC9D6B8), 
        boxShadow: [
          // display a small shadow below the AppBar #MaterialDesign
          BoxShadow(color: Colors.black12, blurRadius: 2.0, spreadRadius: 1.0)
        ],
        ),
        height: 60, // height of the AppBar (it looks fine)
        width: MediaQuery.of(context).size.width, // gets dispay width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(

              // GestureDetector handles tap
              // And the reason why we need the Scaffold key
              onTap: () => _scaffoldKey.currentState.openDrawer(),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Image(
                  height: 50,
                  image: AssetImage('assets/images/logo_square.png'), // Stones logo
                ),
              ),
            ),
            Hero(
              tag: 'title',
              child: Container(
                padding: EdgeInsets.only(right: 64, left: 30),
                child: Text(
                  'Menu', // title is hardcoded, because we're only using this class once
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
