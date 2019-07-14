import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:RPlayer/models/models.dart";

@immutable
abstract class DeviceBrowseState extends Equatable {
  DeviceBrowseState([List props = const []]) : super(props);
}

class DeviceBrowseErrorState extends DeviceBrowseState {}
class DeviceBrowseInitialState extends DeviceBrowseState {}
class DeviceBrowseBusyState extends DeviceBrowseState {}
class DeviceBrowsedState extends DeviceBrowseState {
  final List<DeviceContainer> deviceContainers;

  DeviceBrowsedState({@required this.deviceContainers})
      : assert(deviceContainers != null),
        super([deviceContainers]);
}