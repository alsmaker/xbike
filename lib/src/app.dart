import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xbike/src/page/home.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Home(),
    );
  }

}