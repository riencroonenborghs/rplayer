import 'package:flutter/material.dart';
import "package:upnp/upnp.dart" as upnp;
import "package:RPlayer/pages/pages.dart";

class LocalTabNavigatorRoutes {
  static const String root = '/';
}

class LocalTabNavigator extends StatelessWidget {
  LocalTabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      LocalTabNavigatorRoutes.root: (context) => Text(
        "LOCAL"
      )
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: LocalTabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        // print("onGenerateRoute routeSettings name: ${routeSettings.name}");
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      }
    );
  }
}
