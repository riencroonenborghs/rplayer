import "package:meta/meta.dart";
import "package:equatable/equatable.dart";
import "package:RPlayer/models/models.dart";

@immutable
abstract class BookmarksState extends Equatable {
  BookmarksState([List props = const []]) : super(props);
}

class BookmarksErrorState extends BookmarksState {}
class BookmarksInitialState extends BookmarksState {}
class BookmarksBusyState extends BookmarksState {}
class BookmarksGotState extends BookmarksState {
  final List<Bookmark> bookmarks;

  BookmarksGotState({@required this.bookmarks})
      : assert(bookmarks != null),
        super([bookmarks]);
}