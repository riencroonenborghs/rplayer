import "package:xml/xml.dart";
import "package:upnp/upnp.dart" as upnp;

// <item id="videodb://movies/genres/8/89?genreid=8" parentID="videodb://movies/genres/8/" refID="videodb://movies/titles/89" restricted="1"><dc:title>Tango &amp; Cash</dc:title><dc:creator>Unknown</dc:creator><dc:date>1989-12-22</dc:date><upnp:author>Randy Feldman</upnp:author><upnp:director>Andrei Konchalovsky</upnp:director><upnp:director>Albert Magnoli</upnp:director><dc:publisher>The Guber-Peters Company</dc:publisher><upnp:genre>Action</upnp:genre><upnp:genre>Adventure</upnp:genre><upnp:genre>Comedy</upnp:genre><upnp:albumArtURI dlna:profileID="JPEG_TN">http://192.168.0.111:2010/%25/100EA53A0FDE3805E268068D3310730C/iR2lVzGXYsJpksqUswsnZ7LPTfx.jpg</upnp:albumArtURI><dc:description>Two of L.A.'s top rival cops are going to have to work together... Even if it kills them.</dc:description><upnp:longDescription>Ray Tango and Gabriel Cash are narcotics detectives who, while both being extremely successful, can't stand each other. Crime Lord Yves Perret, furious at the loss of income that T<…>

class DeviceItem {
  upnp.Service _service;
  String _id;
  String _parentId;
  String _title;
  String _director;
  String _albumArtURI;
  String _description;
  String _rating;
  String _poster;
  
  upnp.Service get service => _service;
  String get id => _id;
  String get parentId => _parentId;
  String get title => _title;
  String get director => _director;
  String get albumArtURI => _albumArtURI;
  String get description => _description;
  String get rating => _rating;
  String get poster => _poster;

  DeviceItem.fromXmlElement(upnp.Service service, XmlElement elt) {    
    // print("ITEM");
    // elt.descendants.forEach((d) {
    //   print(d);
    // });

    this._service     = service;    
    this._id          = elt.getAttribute("id");    
    this._parentId    = elt.getAttribute("parentID");    
    this._title       = _text(elt, "dc:title");    
    this._director    = _text(elt, "upnp:director");    
    this._albumArtURI = _text(elt, "upnp:albumArtURI");    
    this._description = _text(elt, "dc:description");
    this._rating      = _text(elt, "xbmc:rating");
    this._poster      = _getPoster(elt);
  }

  String _text(XmlElement elt, String name) {
    Iterable<XmlElement> elements = elt.findElements(name);
    if(elements.length == 0) { return ""; }
    return elements.first.text;
  }
  String _getPoster(XmlElement elt) {
    Iterable<XmlElement> posters = elt.findElements("xbmc:artwork").where((artWork) { return artWork.getAttribute("type") == "poster"; });
    if(posters.length == 0) { return null; }
    return posters.first.text;
  }

  toString() {
    return "item: ${id} - ${title}";
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


// id="videodb://movies/genres/8/115?genreid=8"
// flutter: parentID="videodb://movies/genres/8/"
// flutter: refID="videodb://movies/titles/115"
// flutter: restricted="1"
// flutter: <dc:title>Turner &amp; Hooch</dc:title>
// flutter: Turner &amp; Hooch
// flutter: <dc:creator>Unknown</dc:creator>
// flutter: Unknown
// flutter: <dc:date>1989-07-28</dc:date>
// flutter: 1989-07-28
// flutter: <upnp:author>Dennis Shryack</upnp:author>
// flutter: Dennis Shryack
// flutter: <upnp:author>Michael Blodgett</upnp:author>
// flutter: Michael Blodgett
// flutter: <upnp:director>Roger Spottiswoode</upnp:director>
// flutter: Roger Spottiswoode
// flutter: <dc:publisher>Silver Screen Partners III</dc:publisher>
// flutter: Silver Screen Partners III
// flutter: <upnp:genre>Action</upnp:genre>
// flutter: Action
// flutter: <upnp:genre>Comedy</upnp:genre>
// flutter: Comedy
// flutter: <upnp:genre>Thriller</upnp:genre>
// flutter: Thriller
// flutter: <upnp:genre>Crime</upnp:genre>
// flutter: Crime
// flutter: <upnp:genre>Family</upnp:genre>
// flutter: Family
// flutter: <upnp:albumArtURI dlna:profileID="JPEG_TN">http://192.168.0.111:2010/%25/E6F4F7B78451E56EB305C31C2F0E79B3/oSvaWdWISYCIySdg2TUOHTTapkS.jpg</upnp:albumArtURI>
// flutter: dlna:profileID="JPEG_TN"
// flutter: http://192.168.0.111:2010/%25/E6F4F7B78451E56EB305C31C2F0E79B3/oSvaWdWISYCIySdg2TUOHTTapkS.jpg
// flutter: <dc:description>The Oddest Couple Ever Unleashed!</dc:description>
// flutter: The Oddest Couple Ever Unleashed!
// flutter: <upnp:longDescription>Scott Turner has 3 days left in the local police department before he moves to a bigger city to get some "real" cases, not just misdemeanors. Then Amos Reed is murdered, and Scott Turner sets himself on the case. The closest thing to a witness in the case is Amos Reed's dog, Hooch, which Scott Turner has to take care of if it's going to avoid being "put to sleep".</upnp:longDescription>
// flutter: Scott Turner has 3 days left in the local police department before he moves to a bigger city to get some "real" cases, not just misdemeanors. Then Amos Reed is murdered, and Scott Turner sets himself on the case. The closest thing to a witness in the case is Amos Reed's dog, Hooch, which Scott Turner has to take care of if it's going to avoid being "put to sleep".
// flutter: <upnp:rating>Rated PG</upnp:rating>
// flutter: Rated PG
// flutter: <upnp:lastPlaybackTime>1601-01-01T00:00:00+17:36</upnp:lastPlaybackTime>
// flutter: 1601-01-01T00:00:00+17:36
// flutter: <upnp:playbackCount>0</upnp:playbackCount>
// flutter: 0
// flutter: <upnp:episodeSeason>0</upnp:episodeSeason>
// flutter: 0
// flutter: <res duration="1:40:00.000" protocolInfo="http-get:*:video/mp4:DLNA.ORG_PN=MPEG4_P2_SP_AAC;DLNA.ORG_OP=01;DLNA.ORG_CI=0;DLNA.ORG_FLAGS=01500000000000000000000000000000">http://192.168.0.111:2010/%25/D8DFF94E4CA86F8866EABEDEF45AD6D6/Turner%2520%2526%2520Hooch%2520(1989).mp4</res>
// flutter: duration="1:40:00.000"
// flutter: protocolInfo="http-get:*:video/mp4:DLNA.ORG_PN=MPEG4_P2_SP_AAC;DLNA.ORG_OP=01;DLNA.ORG_CI=0;DLNA.ORG_FLAGS=01500000000000000000000000000000"
// flutter: http://192.168.0.111:2010/%25/D8DFF94E4CA86F8866EABEDEF45AD6D6/Turner%2520%2526%2520Hooch%2520(1989).mp4
// flutter: <res protocolInfo="xbmc.org:*:fanart:*">http://192.168.0.111:2010/%25/41EC0729BADE4EF2AA4374F37097D964/3AQ7BNf15GYoNTa9ZXlhK9oxnng.jpg</res>
// flutter: protocolInfo="xbmc.org:*:fanart:*"
// flutter: http://192.168.0.111:2010/%25/41EC0729BADE4EF2AA4374F37097D964/3AQ7BNf15GYoNTa9ZXlhK9oxnng.jpg
// flutter: <res protocolInfo="xbmc.org:*:poster:*">http://192.168.0.111:2010/%25/E6F4F7B78451E56EB305C31C2F0E79B3/oSvaWdWISYCIySdg2TUOHTTapkS.jpg</res>
// flutter: protocolInfo="xbmc.org:*:poster:*"
// flutter: http://192.168.0.111:2010/%25/E6F4F7B78451E56EB305C31C2F0E79B3/oSvaWdWISYCIySdg2TUOHTTapkS.jpg
// flutter: <xbmc:dateadded>2016-10-02</xbmc:dateadded>
// flutter: 2016-10-02
// flutter: <xbmc:rating>6.1</xbmc:rating>
// flutter: 6.1
// flutter: <xbmc:votes>55380</xbmc:votes>
// flutter: 55380
// flutter: <xbmc:artwork type="fanart">http://192.168.0.111:2010/%25/41EC0729BADE4EF2AA4374F37097D964/3AQ7BNf15GYoNTa9ZXlhK9oxnng.jpg</xbmc:artwork>
// flutter: type="fanart"
// flutter: http://192.168.0.111:2010/%25/41EC0729BADE4EF2AA4374F37097D964/3AQ7BNf15GYoNTa9ZXlhK9oxnng.jpg
// flutter: <xbmc:artwork type="poster">http://192.168.0.111:2010/%25/E6F4F7B78451E56EB305C31C2F0E79B3/oSvaWdWISYCIySdg2TUOHTTapkS.jpg</xbmc:artwork>
// flutter: type="poster"
// flutter: http://192.168.0.111:2010/%25/E6F4F7B78451E56EB305C31C2F0E79B3/oSvaWdWISYCIySdg2TUOHTTapkS.jpg
// flutter: <xbmc:uniqueidentifier>tt0098536</xbmc:uniqueidentifier>
// flutter: tt0098536
// flutter: <xbmc:country>United States of America</xbmc:country>
// flutter: United States of America
// flutter: <xbmc:userrating>0</xbmc:userrating>
// flutter: 0
// flutter: <upnp:class>object.item.videoItem.movie</upnp:class>
// flutter: object.item.videoItem.movie