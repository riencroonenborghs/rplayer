import "package:meta/meta.dart";

@immutable
abstract class BookmarksEvent {}

class GetBookmarksEvent extends BookmarksEvent {}