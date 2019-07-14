import "package:meta/meta.dart";
import "package:upnp/upnp.dart";
import "package:equatable/equatable.dart";

abstract class BaseDeviceBrowseEvent extends Equatable {
  BaseDeviceBrowseEvent([List props = const []]) : super(props);
}

class DeviceBrowseEvent extends BaseDeviceBrowseEvent {
  final dynamic browseableObject;

  DeviceBrowseEvent({@required this.browseableObject})
      : assert(browseableObject != null),
        super([browseableObject]);
}