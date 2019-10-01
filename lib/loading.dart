import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'functions.dart';
import 'localdb.dart';

class LoadingScreen extends StatefulWidget {
  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  bool c = true;

  Future checkBackground(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1), () async {
      while (true) {
        if (!LocalDB.loading) {
          try {
            Navigator.of(context).pushReplacementNamed("/orders");
            Functions.setUiColors(Color(0xFF838c77), true);
            return;
          } catch (e) {
            print("yeet");
          }
        }
        await sleep1();
      }
    });
  }

  Future sleep1() {
    return new Future.delayed(const Duration(milliseconds: 300), () => "300");
  }

  @override
  Widget build(BuildContext context) {
    if(c) {
      c = false;
      checkBackground(context);
    }

    return Scaffold(
      backgroundColor: Color(0xFFAA7B47),
      body: Container(
        child: Center(
          child: SpinKitWave(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
