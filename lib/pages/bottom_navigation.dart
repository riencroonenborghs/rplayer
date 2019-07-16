import 'package:flutter/material.dart';
import "package:RPlayer/pages/pages.dart";

// Widget local            = Text("Local");
// Widget deviceDiscoverer = DeviceDiscoverer();
// Widget bookmarks        = Bookmarks();

enum TabItem { local, deviceDiscoverer, bookmarks }

class TabHelper {
  static TabItem item({int index}) {
    if(index == 0) { return TabItem.local; }
    if(index == 1) { return TabItem.deviceDiscoverer; }
    if(index == 2) { return TabItem.bookmarks; }
    return TabItem.bookmarks;
  }

  static String description(TabItem tabItem) {
    if(tabItem == TabItem.local) { return "Local"; }
    if(tabItem == TabItem.deviceDiscoverer) { return "Network"; }
    if(tabItem == TabItem.bookmarks) { return "Bookmarks"; }
    return "";
  }
  static IconData icon(TabItem tabItem) {
    if(tabItem == TabItem.local) { return Icons.location_on; }
    if(tabItem == TabItem.deviceDiscoverer) { return Icons.wifi; }
    if(tabItem == TabItem.bookmarks) { return Icons.bookmark_border; }
    return Icons.wifi;
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(tabItem: TabItem.local),
        _buildItem(tabItem: TabItem.deviceDiscoverer),
        _buildItem(tabItem: TabItem.bookmarks),
      ],
      onTap: (index) => onSelectTab(
        TabHelper.item(index: index)
      ),
    );
  }

  BottomNavigationBarItem _buildItem({TabItem tabItem}) {
    String text   = TabHelper.description(tabItem);
    IconData icon = TabHelper.icon(tabItem);
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? Colors.green : Colors.grey;
  }
}