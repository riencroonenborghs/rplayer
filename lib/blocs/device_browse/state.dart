import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:upnp/upnp.dart";

@immutable
abstract class DeviceBrowseState extends Equatable {
  DeviceBrowseState([List props = const []]) : super(props);
}

class DeviceBrowseErrorState extends DeviceBrowseState {}
class DeviceBrowseInitialState extends DeviceBrowseState {}
class DeviceBrowseBusyState extends DeviceBrowseState {}
class DeviceBrowsedState extends DeviceBrowseState {
  final List<Service> services;

  DeviceBrowsedState({@required this.services})
      : assert(services != null),
        super([services]);
}