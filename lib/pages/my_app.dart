import 'package:flutter/material.dart';
import "package:RPlayer/pages/pages.dart";

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  TabItem currentTab = TabItem.deviceDiscoverer;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.local: GlobalKey<NavigatorState>(),
    TabItem.deviceDiscoverer: GlobalKey<NavigatorState>(),
    TabItem.bookmarks: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentTab].currentState.maybePop(),
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.local),
          _buildOffstageNavigator(TabItem.deviceDiscoverer),
          _buildOffstageNavigator(TabItem.bookmarks),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    Widget child;
    if(tabItem == TabItem.deviceDiscoverer) {
      child = DeviceDiscovererTabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem
      );
    }
    if(tabItem == TabItem.local) {
      child = LocalTabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem
      );
    }
    if(tabItem == TabItem.bookmarks) {
      child = BookmarksTabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        tabItem: tabItem
      );
    }
    return Offstage(
      offstage: currentTab != tabItem,
      child: child
    );
  }
}
