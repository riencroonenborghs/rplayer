import "package:xml/xml.dart";
import "package:upnp/upnp.dart" as upnp;

// <container id="musicdb://" parentID="0" restricted="1" searchable="0"><dc:title>Music Library</dc:title><dc:creator>Unknown</dc:creator><dc:publisher>Unknown</dc:publisher><upnp:genre>Unknown</upnp:genre><upnp:episodeSeason>0</upnp:episodeSeason><xbmc:rating>0.0</xbmc:rating><xbmc:userrating>0</xbmc:userrating><upnp:class>object.container</upnp:class></container>

class DeviceContainer {
  upnp.Service _service;
  String _id;
  String _parentId;
  String _title;
  
  upnp.Service get service => _service;
  String get id => _id;
  String get parentId => _parentId;
  String get title => _title;

  DeviceContainer.fromXmlElement(upnp.Service service, XmlElement elt) {
    this._service   = service;
    this._id        = elt.getAttribute("id");
    this._parentId  = elt.getAttribute("parentID");
    this._title     = _text(elt, "dc:title");
  }

  String _text(XmlElement elt, String name) {
    Iterable<XmlElement> elements = elt.findElements(name);
    if(elements.length == 0) { return ""; }
    return elements.first.text;
  }

  toString() {
    return "${id} ${title}";
  }

  // Map<String, dynamic> toMap() {
  //   var map = new Map<String, dynamic>();
  //   map["id"]       = _id;
  //   map["name"]     = _name;
  //   map["network"]  = _network;
  //   map["location"] = _location;
  //   map["icon"]     = _icon;
  //   return map;
  // }
}