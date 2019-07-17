import "package:flutter/material.dart";
import "package:upnp/upnp.dart";
import "package:xml/xml.dart" as xml;
import "package:bloc/bloc.dart";
import "package:RPlayer/blocs/blocs.dart";

final String ContentDirectory = "urn:schemas-upnp-org:service:ContentDirectory:1";

class DeviceDiscoverBloc extends Bloc<DeviceDiscoverEvent, DeviceDiscoverState> {
  DeviceDiscoverBloc();

  @override
  DeviceDiscoverState get initialState => DeviceDiscoverInitialState();

  Future<Service> getService(Device device) async {
    Service service = await device.getService(ContentDirectory);
    return service;
  }

  @override
  Stream<DeviceDiscoverState> mapEventToState(DeviceDiscoverEvent event) async* {
    if (event is DeviceDiscoverEvent) {
      yield DeviceDiscoverBusyState();
      try {
        Stream<Service> stream = _discoverServices();
        List<Service> services = await _discover(stream);
        yield DeviceDiscoveredState(services: services);      
      } catch (e) {
        print(e);
        yield DeviceDiscoverErrorState();
      }
    }
  }

  Future<List<Service>> _discover(Stream<Service> stream) async {
    List<Service> services = new List<Service>();
    await for (Service service in stream) { services.add(service); }
    return services;
  }
  Stream<Service> _discoverServices() async* {
    DeviceDiscoverer discover = new DeviceDiscoverer();
    List<DiscoveredDevice> discoveredDevices = await discover.discoverDevices();
    for(DiscoveredDevice discoveredDevice in discoveredDevices) {
      Device device = await discoveredDevice.getRealDevice();
      Service service = await device.getService(ContentDirectory);
      if(service != null) { yield service; }
    }
  }
}