import "package:flutter/material.dart";

class MainScaffold extends StatefulWidget {
  final String title;
  final List<Widget> actions;
  final Widget child;

  MainScaffold({Key key, @required this.title, @required this.child, this.actions}) : super(key: key);

  @override
  _MainScaffoldState createState() =>  _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext buildContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions
      ),      
      body: SingleChildScrollView(child: widget.child)
    );
  }
}