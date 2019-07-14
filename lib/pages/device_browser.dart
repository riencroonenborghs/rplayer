import "package:flutter/material.dart";
import "package:upnp/upnp.dart" as upnp;
import "package:flutter_bloc/flutter_bloc.dart";

import "package:RPlayer/widgets/widgets.dart";
import "package:RPlayer/blocs/blocs.dart";

class DeviceBrowser extends StatefulWidget {
  const DeviceBrowser();
  
  @override
  _DeviceBrowserState createState() => _DeviceBrowserState();
}

class _DeviceBrowserState extends State<DeviceBrowser> {  
  DeviceBrowseBloc deviceBrowseBloc;
  upnp.Service service;

  @override
  void initState() {
    deviceBrowseBloc = DeviceBrowseBloc();
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

  // Widget _listDevices() {
  //   List<Widget> devices = new List<Widget>();
  //   for(upnp.Service service in foundServices) {
  //     ListTile deviceTile = ListTile(
  //       title: Row(children: [Text(service.device.friendlyName)]),
  //       subtitle: Row(children: [Text(service.device.modelDescription, style: TextStyle(fontSize: 10))]),
  //       trailing: Icon(Icons.chevron_right),
  //       onTap: () {
  //         // deviceBrowseBloc.dispatch(DeviceBrowseEvent(service: service));
  //       }
  //     );
  //     devices.add(deviceTile);
  //   };

  //   return Flexible(
  //     child: Column(
  //       children: devices
  //     )
  //   );
  // }

  Widget _browsingDevices() {
    return BlocBuilder<DeviceBrowseEvent, DeviceBrowseState>(
      bloc: deviceBrowseBloc,
      builder: (_, DeviceBrowseState state) {
        // discover
        if(state is DeviceBrowseInitialState) {
          return _waiting("Browsing ${service.device.friendlyName}...");
        }
        if(state is DeviceBrowseBusyState) {      
          return _waiting("Browsing ${service.device.friendlyName}...");
        }
        if(state is DeviceBrowsedState) {
          return Text("DONE");
        }
        if(state is DeviceBrowseErrorState) {      
          return Text("Error happened :(", style: TextStyle(color: Colors.red[700]));
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    service = ModalRoute.of(context).settings.arguments;

    Container mainContainer = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ _browsingDevices() ]
      )
    );

    deviceBrowseBloc.dispatch(DeviceBrowseEvent(service: service));

    return MainScaffold(
      title: "RPlayer",
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: mainContainer
      )
    );
  }
}