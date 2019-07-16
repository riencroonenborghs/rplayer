import "package:flutter/material.dart";
import "package:upnp/upnp.dart" as upnp;
import "package:flutter_bloc/flutter_bloc.dart";

import "package:RPlayer/widgets/widgets.dart";
import "package:RPlayer/blocs/blocs.dart";
import "package:RPlayer/models/models.dart";
import "package:RPlayer/utils/utils.dart";

class Bookmarks extends StatefulWidget {
  final VoidCallback onPush;
  Bookmarks({Key key, @required this.onPush}) : super(key: key);

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {  
  BuildContext buildContext;
  BookmarksBloc bookmarksBloc;
  List<Bookmark> bookmarks;

  @override
  void initState() {
    bookmarksBloc = BookmarksBloc();
  }

  Widget _waiting(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: <Widget> [
            CircularProgressIndicator(value: null),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(label, style: TextStyle(fontSize: 8.0))
            )        
          ]
        )
      ]
    );
  }

  Widget _listBookmarks() {
    List<Widget> bookmarksWidgets = new List<Widget>();
    for(Bookmark bookmark in bookmarks) {
      ListTile bookmarkTile = ListTile(
        title: Row(children: [Text(bookmark.name)]),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          widget.onPush();
          // Navigator.pushNamed(
          //   buildContext,
          //   "/browser",
          //   arguments: service
          // );
        }
      );
      bookmarksWidgets.add(bookmarkTile);
    };

    return Flexible(
      child: Column(
        children: bookmarksWidgets
      )
    );
  }

  Widget _showBookmarks() {
    return BlocBuilder<BookmarksEvent, BookmarksState>(
      bloc: bookmarksBloc,
      builder: (_, BookmarksState state) {
        if(state is BookmarksInitialState) {
          return _waiting("Getting bookmarks...");
        }
        if(state is BookmarksBusyState) {      
          return _waiting("Getting bookmarks...");
        }
        if(state is BookmarksGotState) {
          bookmarks = state.bookmarks;
          return _listBookmarks();
        }
        if(state is BookmarksErrorState) {      
          return Text("Error happened :(", style: TextStyle(color: Colors.red[700]));
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;

    Container mainContainer = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ _showBookmarks() ]
      )
    );

    if(bookmarks == null) {
      bookmarksBloc.dispatch(GetBookmarksEvent()); 
    }

    return MainScaffold(
      title: "RPlayer",
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: mainContainer
      )
    );
  }
}