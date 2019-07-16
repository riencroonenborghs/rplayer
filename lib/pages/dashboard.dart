import "package:flutter/material.dart";
import "package:RPlayer/pages/pages.dart";

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() =>  _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    // Text("Local"),
    // DeviceDiscoverer(),
    // Bookmarks()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            title: Text('Local'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi), // wifi / share
            title: Text('Network'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            title: Text('Bookmarks'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedFontSize: 12,
        onTap: _onItemTapped,
      )
    );
  }
}