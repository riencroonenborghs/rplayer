import "package:flutter/material.dart";
import "package:upnp/upnp.dart";
import "package:xml/xml.dart" as xml;
import "package:bloc/bloc.dart";
import "package:RPlayer/blocs/blocs.dart";
import "package:RPlayer/models/models.dart";

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
        List<DeviceContainer> deviceContainers = await _browse(event.browseableObject);
        yield DeviceBrowsedState(deviceContainers: deviceContainers);
      } catch (e) {
        print(e);
        yield DeviceBrowseErrorState();
      }
    }
  }

  Future<List<DeviceContainer>> _browse(dynamic browseableObject) async {
    List<DeviceContainer> deviceContainers = new List<DeviceContainer>();
    Action action = service.actions.firstWhere((action) => action.name == "Browse");

    dynamic args = {
      "ObjectID": (browseableObject is Service) ? 0 : browseableObject.id,
      "BrowseFlag": "BrowseDirectChildren",
      "Filter": "*",
      "StartingIndex": 0,
      "RequestedCount": 0,
      "SortCriteria": ""
    };

    var data      = await action.invoke(args);
    String result = data["Result"];
    var document  = xml.parse(result);
    document.findAllElements("container").forEach((xmlElt) {
      deviceContainers.add(
        DeviceContainer.fromXmlElement(service, xmlElt)
      );
    });
    return deviceContainers;
  }
}