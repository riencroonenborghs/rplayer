import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:upnp/upnp.dart";

@immutable
abstract class DeviceDiscoverState extends Equatable {
  DeviceDiscoverState([List props = const []]) : super(props);
}

class DeviceDiscoverErrorState extends DeviceDiscoverState {}
class DeviceDiscoverInitialState extends DeviceDiscoverState {}
class DeviceDiscoverBusyState extends DeviceDiscoverState {}
class DeviceDiscoveredState extends DeviceDiscoverState {
  final List<Service> services;

  DeviceDiscoveredState({@required this.services})
      : assert(services != null),
        super([services]);
}