import 'package:flutter/material.dart';
import "package:upnp/upnp.dart" as upnp;
import "package:RPlayer/pages/pages.dart";

class BookmarksTabNavigatorRoutes {
  static const String root = '/';
  static const String deviceBrowser = '/browser';
}

class BookmarksTabNavigator extends StatelessWidget {
  BookmarksTabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;
  dynamic routeArguments;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      BookmarksTabNavigatorRoutes.root: (context) => Bookmarks(
        onBookmarkPush: (service) {
          Navigator.pushNamed(
            context,
            "/browser",
            arguments: service
          );
        },
        onBookmarkRemoved: () {
          Navigator.pushNamed(
            context,
            "/"
          );
        }
      ),
      DeviceDiscovererTabNavigatorRoutes.deviceBrowser: (context) => DeviceBrowser(
        source: routeArguments,
        onPush: (deviceContainer) {
          Navigator.pushNamed(
            context,
            "/browser",
            arguments: deviceContainer
          );
        }
      )
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: BookmarksTabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        routeArguments = routeSettings.arguments;
        // print("onGenerateRoute routeSettings name: ${routeSettings.name}");
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name](context),
        );
      }
    );
  }
}
