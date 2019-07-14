import "package:flutter/material.dart";
import "package:bloc/bloc.dart";
import "package:RPlayer/blocs/blocs.dart";
import "package:RPlayer/utils/utils.dart";
import "package:RPlayer/models/models.dart";

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  BookmarksBloc();

  @override
  BookmarksState get initialState => BookmarksInitialState();

  @override
  Stream<BookmarksState> mapEventToState(BookmarksEvent event) async* {
    if (event is GetBookmarksEvent) {
      yield BookmarksBusyState();
      try {
        List<Bookmark> bookmarks = await _getBookmarks();
        yield BookmarksGotState(bookmarks: bookmarks);      
      } catch (e) {
        print(e);
        yield BookmarksErrorState();
      }
    }
  }

  Future<List<Bookmark>> _getBookmarks() async {
    DatabaseHelper db = new DatabaseHelper();
    return db.getBookmarks();
  }
}