import 'package:flutter/material.dart';
import "package:upnp/upnp.dart" as upnp;
import "package:RPlayer/pages/pages.dart";

class BookmarksTabNavigatorRoutes {
  static const String root = '/';
}

class BookmarksTabNavigator extends StatelessWidget {
  BookmarksTabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      BookmarksTabNavigatorRoutes.root: (context) => Bookmarks(
        onPush: () => {}
      ) 
    };
  }

  dynamic routeArguments;
  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: BookmarksTabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        routeArguments = routeSettings.arguments;
        // print("onGenerateRoute routeSettings arguments: ${routeSettings.arguments}");
        // print("onGenerateRoute routeSettings name: ${routeSettings.name}");
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      }
    );
  }
}
