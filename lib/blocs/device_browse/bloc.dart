import "package:flutter/material.dart";
import "package:upnp/upnp.dart";
import "package:xml/xml.dart" as xml;
import "package:bloc/bloc.dart";
import "package:RPlayer/blocs/blocs.dart";
import "package:RPlayer/models/models.dart";

import 'dart:developer' as developer;


class DeviceBrowseBloc extends Bloc<DeviceBrowseEvent, DeviceBrowseState> {
  Service service;
  DeviceBrowseBloc({@required this.service});

  @override
  DeviceBrowseState get initialState => DeviceBrowseInitialState();

  @override
  Stream<DeviceBrowseState> mapEventToState(DeviceBrowseEvent event) async* {
    if (event is DeviceBrowseEvent) {
      yield DeviceBrowseBusyState();
      try {
        dynamic data = await _browse(event.browseableObject);
        List<DeviceContainer> deviceContainers = data[0];
        List<DeviceItem> deviceItems = data[1];
        yield DeviceBrowsedState(deviceContainers: deviceContainers, deviceItems: deviceItems);
      } catch (e) {
        print(e);
        yield DeviceBrowseErrorState();
      }
    }
  }

  Future<List<dynamic>> _browse(dynamic browseableObject) async {
    List<DeviceContainer> deviceContainers = new List<DeviceContainer>();
    List<DeviceItem> deviceItems = new List<DeviceItem>();
    Action action = service.actions.firstWhere((action) => action.name == "Browse");

    dynamic args = {
      "ObjectID": (browseableObject is Service) ? 0 : browseableObject.id,
      "BrowseFlag": "BrowseDirectChildren",
      "Filter": "*",
      "StartingIndex": 0,
      "RequestedCount": 0,
      "SortCriteria": ""
    };

    var actionData          = await action.invoke(args);
    String actionDataResult = actionData["Result"];
    var document            = xml.parse(actionDataResult);
    document.findAllElements("container").forEach((xmlElt) {
      deviceContainers.add(
        DeviceContainer.fromXmlElement(service, xmlElt)
      );
    });
    document.findAllElements("item").forEach((xmlElt) {
      deviceItems.add(
        DeviceItem.fromXmlElement(service, xmlElt)
      );
    });

    List<dynamic> resultData = new List<dynamic>();
    resultData.add(deviceContainers);
    resultData.add(deviceItems);
    return resultData;
  }
}