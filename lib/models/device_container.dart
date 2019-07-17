import "package:xml/xml.dart";
import "package:upnp/upnp.dart" as upnp;

// <container id="musicdb://" parentID="0" restricted="1" searchable="0"><dc:title>Music Library</dc:title><dc:creator>Unknown</dc:creator><dc:publisher>Unknown</dc:publisher><upnp:genre>Unknown</upnp:genre><upnp:episodeSeason>0</upnp:episodeSeason><xbmc:rating>0.0</xbmc:rating><xbmc:userrating>0</xbmc:userrating><upnp:class>object.container</upnp:class></container>

class DeviceContainer {
  upnp.Service _service;
  String _id;
  String _parentId;
  String _title;
  String _rating;
  String _poster;
  
  upnp.Service get service => _service;
  String get id => _id;
  String get parentId => _parentId;
  String get title => _title;
  String get rating => _rating;
  String get poster => _poster;

  DeviceContainer.fromXmlElement(upnp.Service service, XmlElement elt) {
    this._service   = service;
    this._id        = elt.getAttribute("id");
    this._parentId  = elt.getAttribute("parentID");
    this._title     = _text(elt, "dc:title");
    this._rating      = _text(elt, "xbmc:rating");
    this._poster    = _getPoster(elt);
  }

  String _text(XmlElement elt, String name) {
    Iterable<XmlElement> elements = elt.findElements(name);
    if(elements.length == 0) { return ""; }
    return elements.first.text;
  }

  String _getPoster(XmlElement elt) {
    Iterable<XmlElement> posters = elt.findElements("upnp:albumArtURI").where((artWork) { return artWork.getAttribute("dlna:profileID") == "JPEG_TN"; });
    if(posters.length == 0) { return null; }
    return posters.first.text;
  }

  toString() {
    return "container: ${id} - ${title}";
  }
}