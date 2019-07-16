import "package:flutter/material.dart";
import "package:upnp/upnp.dart" as upnp;
import "package:flutter_bloc/flutter_bloc.dart";

import "package:RPlayer/widgets/widgets.dart";
import "package:RPlayer/blocs/blocs.dart";
import "package:RPlayer/models/models.dart";

class DeviceBrowser extends StatefulWidget {
  final ValueChanged<dynamic> onPush;
  final dynamic source;
  DeviceBrowser({Key key, @required this.onPush, @required this.source}) : super(key: key);
  
  @override
  _DeviceBrowserState createState() => _DeviceBrowserState();
}

class _DeviceBrowserState extends State<DeviceBrowser> {
  BuildContext buildContext;
  DeviceBrowseBloc deviceBrowseBloc;
  List<DeviceContainer> deviceContainers;
  List<DeviceItem> deviceItems;

  Widget _waiting() {
    String label;
    if(widget.source is upnp.Service) { label = "Browsing ${widget.source.device.friendlyName}..."; }
    else { label = "Browsing ${widget.source.title}..."; }

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

  Widget _listText(String text) {
    return Row(
      children: [
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis
          )
        )
      ]
    );
  }


  Widget _listContainersOrItems() {
    List<Widget> containerWidgets = new List<Widget>();

    // containers
    for(DeviceContainer deviceContainer in deviceContainers) {
      ListTile containerTile = ListTile(
        title: _listText(deviceContainer.title),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          widget.onPush(deviceContainer);
          // Navigator.pushNamed(
          //   buildContext,
          //   "/browser",
          //   arguments: deviceContainer
          // );
        }
      );
      containerWidgets.add(containerTile);
    };

    // items
    for(DeviceItem deviceItem in deviceItems) {
      ListTile itemTile = ListTile(
        leading: deviceItem.poster != null ? Image.network(deviceItem.poster) : Container(),
        title: _listText(deviceItem.title),
        subtitle: Row(children: [
          Icon(Icons.star_border),
          Text(deviceItem.rating)
        ]),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pushNamed(
            buildContext,
            "/playable-item",
            arguments: deviceItem
          );
        }
      );
      containerWidgets.add(itemTile);
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
          deviceItems = state.deviceItems;
          return _listContainersOrItems();
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

    deviceBrowseBloc = DeviceBrowseBloc(service: (widget.source is upnp.Service) ? widget.source : widget.source.service);

    Container mainContainer = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ _browsingDevices() ]
      )
    );

    deviceBrowseBloc.dispatch(DeviceBrowseEvent(browseableObject: widget.source));

    return MainScaffold(
      title: "RPlayer",
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: mainContainer
      )
    );
  }
}