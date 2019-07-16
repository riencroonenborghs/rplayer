import 'package:flutter/material.dart';
import "package:upnp/upnp.dart" as upnp;
import "package:RPlayer/pages/pages.dart";

class DeviceDiscovererTabNavigatorRoutes {
  static const String root = '/';
  static const String local = '/local';
  static const String deviceDiscoverer = '/discoverer';
  static const String deviceBrowser = '/browser';
  static const String bookmarks = '/bookmarks';
}

class DeviceDiscovererTabNavigator extends StatelessWidget {
  DeviceDiscovererTabNavigator({this.navigatorKey, this.tabItem});
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      // DeviceDiscovererTabNavigatorRoutes.root: (context) => Bookmarks(
      //   onPush: () => {}
      // ),
      // DeviceDiscovererTabNavigatorRoutes.bookmarks: (context) => Bookmarks(
      //   onPush: () => {}
      // ),
      DeviceDiscovererTabNavigatorRoutes.root: (context) => DeviceDiscoverer(
        onPush: (service) {
          Navigator.pushNamed(
            context,
            "/browser",
            arguments: service
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
      ),
      // DeviceDiscovererTabNavigatorRoutes.local: (context) => Text("local")
    };
  }

  dynamic routeArguments;
  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: DeviceDiscovererTabNavigatorRoutes.root,
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
