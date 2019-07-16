import "package:flutter/material.dart";
import "package:RPlayer/utils/utils.dart";
import "package:RPlayer/routes.dart";
import "package:RPlayer/pages/pages.dart";

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RPlayer",
      routes: routes,
      theme: ThemeData(primarySwatch: Colors.green),
      home: MyApp()
    );
  }
}