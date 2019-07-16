import "package:flutter/material.dart";
import "package:upnp/upnp.dart" as upnp;
import "package:flutter_bloc/flutter_bloc.dart";

import "package:RPlayer/widgets/widgets.dart";
import "package:RPlayer/blocs/blocs.dart";
import "package:RPlayer/models/models.dart";
import "package:RPlayer/utils/utils.dart";

class DeviceDiscoverer extends StatefulWidget {
  // const DeviceDiscoverer();
  final ValueChanged<upnp.Service> onPush;
  DeviceDiscoverer({Key key, @required this.onPush}) : super(key: key);

  @override
  _DeviceDiscovererState createState() => _DeviceDiscovererState();
}

class _DeviceDiscovererState extends State<DeviceDiscoverer> {  
  BuildContext buildContext;
  DeviceDiscoverBloc deviceDiscoverBloc;
  List<upnp.Service> foundServices;

  @override
  void initState() {
    deviceDiscoverBloc = DeviceDiscoverBloc();
  }

  Widget _waiting(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: <Widget> [
            CircularProgressIndicator(value: null),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(label, style: TextStyle(fontSize: 8.0))
            )        
          ]
        )
      ]
    );
  }

  Widget _popUpMenu(upnp.Service service) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      onSelected: (String type) { 
        if(type == "bookmark") {
          DatabaseHelper db = new DatabaseHelper();
          Bookmark bookmark = Bookmark.fromService(service);
          db.saveBookmark(bookmark).then((result) {
            if(result) {
              Scaffold.of(buildContext).showSnackBar(
                new SnackBar(
                  content: new Text("Bookmark added."),
                  duration: new Duration(seconds: 3)
                )
              );
            }
          });          
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "bookmark",
          child: Text("Add bookmark"),
        )
      ],
    );
  }

  Widget _listDevices() {
    List<Widget> devices = new List<Widget>();
    for(upnp.Service service in foundServices) {
      ListTile deviceTile = ListTile(
        title: Row(children: [Text(service.device.friendlyName)]),
        subtitle: Row(children: [Text(service.device.modelDescription, style: TextStyle(fontSize: 10))]),
        trailing: _popUpMenu(service),
        onTap: () {
          widget.onPush(service);
          // Navigator.pushNamed(
          //   buildContext,
          //   "/browser",
          //   arguments: service
          // );
        }
      );
      devices.add(deviceTile);
    };

    return Flexible(
      child: Column(
        children: devices
      )
    );
  }

  Widget _discoveringDevices() {
    return BlocBuilder<DeviceDiscoverEvent, DeviceDiscoverState>(
      bloc: deviceDiscoverBloc,
      builder: (_, DeviceDiscoverState state) {
        if(state is DeviceDiscoverInitialState) {
          return _waiting("Discovering devices...");
        }
        if(state is DeviceDiscoverBusyState) {      
          return _waiting("Discovering devices...");
        }
        if(state is DeviceDiscoveredState) {
          foundServices = state.services;
          return _listDevices();
        }
        if(state is DeviceDiscoverErrorState) {      
          return Text("Error happened :(", style: TextStyle(color: Colors.red[700]));
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    Container mainContainer = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ _discoveringDevices() ]
      )
    );

    if(foundServices == null) {
      deviceDiscoverBloc.dispatch(DeviceDiscoverEvent()); 
    }

    return MainScaffold(
      title: "RPlayer",
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: mainContainer
      )
    );
  }
}