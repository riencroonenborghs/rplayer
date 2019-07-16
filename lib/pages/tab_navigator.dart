import 'package:flutter/material.dart';
import "package:upnp/upnp.dart" as upnp;
import "package:RPlayer/pages/pages.dart";

class TabNavigatorRoutes {
  static const String root = '/';
  static const String local = '/local';
  static const String deviceDiscoverer = '/discoverer';
  static const String deviceBrowser = '/browser';
  static const String bookmarks = '/bookmarks';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => Bookmarks(
        onPush: () => {}
      ),
      TabNavigatorRoutes.bookmarks: (context) => Bookmarks(
        onPush: () => {}
      ),
      TabNavigatorRoutes.deviceDiscoverer: (context) => DeviceDiscoverer(
        onPush: (service) {
          Navigator.pushNamed(
            context,
            "/browser",
            arguments: service
          );
        }
      ),
      TabNavigatorRoutes.deviceBrowser: (context) => DeviceBrowser(
        source: routeArguments,
        onPush: (deviceContainer) {
          Navigator.pushNamed(
            context,
            "/browser",
            arguments: deviceContainer
          );
        }
      ),
      TabNavigatorRoutes.local: (context) => Text("local")
    };
  }

  dynamic routeArguments;
  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.deviceDiscoverer,
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
