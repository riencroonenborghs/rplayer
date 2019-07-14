import "package:upnp/upnp.dart";

class Bookmark {
  int _id;
  String _name;
  int _network;
  String _location;
  String _icon;

  int get id => _id;
  String get name => _name;
  int get network => _network;
  String get location => _location;
  String get icon => _icon;

  Bookmark.fromService(Service service) {
    this._name      = service.device.friendlyName;
    this._network   = 1;
    this._location  = service.controlUrl;
    this._icon      = "wifi";
  }

  Bookmark.fromMap(dynamic obj) {
    this._id        = obj["id"];
    this._name      = obj["name"];
    this._network   = obj["network"];
    this._location  = obj["location"];
    this._icon      = obj["icon"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"]       = _id;
    map["name"]     = _name;
    map["network"]  = _network;
    map["location"] = _location;
    map["icon"]     = _icon;
    return map;
  }
}