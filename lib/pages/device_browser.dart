import "package:flutter/material.dart";
import "package:upnp/upnp.dart" as upnp;
import "package:flutter_bloc/flutter_bloc.dart";

import "package:RPlayer/widgets/widgets.dart";
import "package:RPlayer/blocs/blocs.dart";
import "package:RPlayer/models/models.dart";

class DeviceBrowser extends StatefulWidget {
  const DeviceBrowser();
  
  @override
  _DeviceBrowserState createState() => _DeviceBrowserState();
}

class _DeviceBrowserState extends State<DeviceBrowser> {
  BuildContext buildContext;
  DeviceBrowseBloc deviceBrowseBloc;
  dynamic pageArgument;
  List<DeviceContainer> deviceContainers;

  Widget _waiting() {
    String label;
    if(pageArgument is upnp.Service) { label = "Browsing ${pageArgument.device.friendlyName}..."; }
    else { label = "Browsing ${pageArgument.title}..."; }

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

  Widget _listContainers() {
    List<Widget> containerWidgets = new List<Widget>();
    for(DeviceContainer deviceContainer in deviceContainers) {
      print(deviceContainer);
      ListTile containerTile = ListTile(
        title: Row(children: [Text(deviceContainer.title)]),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pushNamed(
            buildContext,
            "/browser",
            arguments: deviceContainer
          );
        }
      );
      containerWidgets.add(containerTile);
    };

    return Flexible(
      child: Column(
        children: containerWidgets
      )
    );
  }

  Widget _browsingDevices() {
    return BlocBuilder<DeviceBrowseEvent, DeviceBrowseState>(
      bloc: deviceBrowseBloc,
      builder: (_, DeviceBrowseState state) {
        if(state is DeviceBrowseInitialState) {
          return _waiting();
        }
        if(state is DeviceBrowseBusyState) {      
          return _waiting();
        }
        if(state is DeviceBrowsedState) {
          deviceContainers = state.deviceContainers;
          return _listContainers();
        }
        if(state is DeviceBrowseErrorState) {      
          return Text("Error happened :(", style: TextStyle(color: Colors.red[700]));
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    pageArgument = ModalRoute.of(context).settings.arguments;

    deviceBrowseBloc = DeviceBrowseBloc(service: (pageArgument is upnp.Service) ? pageArgument : pageArgument.service);

    Container mainContainer = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ _browsingDevices() ]
      )
    );

    deviceBrowseBloc.dispatch(DeviceBrowseEvent(browseableObject: pageArgument));

    return MainScaffold(
      title: "RPlayer",
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: mainContainer
      )
    );
  }
}