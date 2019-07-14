import "package:flutter/material.dart";
import "package:upnp/upnp.dart";
import "package:xml/xml.dart" as xml;
import "package:bloc/bloc.dart";
import "package:RPlayer/blocs/blocs.dart";


class DeviceBrowseBloc extends Bloc<DeviceBrowseEvent, DeviceBrowseState> {
  DeviceBrowseBloc();

  @override
  DeviceBrowseState get initialState => DeviceBrowseInitialState();

  @override
  Stream<DeviceBrowseState> mapEventToState(DeviceBrowseEvent event) async* {
    if (event is DeviceBrowseEvent) {
      yield DeviceBrowseBusyState();
      try {
        _browse(event.service);
      } catch (_) {
        yield DeviceBrowseErrorState();
      }
    }
  }

  _browse(Service service) {
    Action action = service.actions.firstWhere((action) => action.name == "Browse");
    dynamic args = {
      "ObjectID": 0,
      "BrowseFlag": "BrowseDirectChildren",
      "Filter": "*",
      "StartingIndex": 0,
      "RequestedCount": 0,
      "SortCriteria": ""
    };
    action.invoke(args).then((data) {
      String result = data["Result"];
      var doc = xml.parse(result);
      print(doc);
      // data.forEach((key, value) {
      //   print(key);
      // });
    });
  }
}