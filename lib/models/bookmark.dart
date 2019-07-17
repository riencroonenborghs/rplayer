import "package:upnp/upnp.dart";
import "package:xml/xml.dart" as xmlLib;

class Bookmark {
  int _id;
  String _name;
  String _description;
  String _url;
  String _xml;

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get url => _url;
  String get xml => _xml;

  Bookmark.fromDevice(Device device) {
    this._name        = device.friendlyName;
    this._description = device.modelDescription;
    this._url         = device.url;
    this._xml         = device.deviceElement.toXmlString();
  }

  Device toDevice() {
    Device device = new Device();
    xmlLib.XmlDocument doc = xmlLib.parse(this._xml);
    device.loadFromXml(this._url, doc.rootElement);
    return device;
  }

  Bookmark.fromMap(dynamic obj) {
    this._id          = obj["id"];
    this._name        = obj["name"];
    this._description = obj["description"];
    this._url         = obj["url"];
    this._xml         = obj["xml"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"]           = _id;
    map["name"]         = _name;
    map["description"]  = _description;
    map["url"]          = _url;
    map["xml"]          = _xml;
    return map;
  }
}