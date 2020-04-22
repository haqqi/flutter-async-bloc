import 'package:equatable/equatable.dart';

// base event
abstract class ULEvent extends Equatable {
  const ULEvent();

  @override
  List<Object> get props => [
        runtimeType,
      ];
}

// fetching, must bring the meta
class ULFetchEvent extends ULEvent {}

/// Refresh the page by using refresh indicator
class ULRefreshEvent extends ULEvent {}

/// Submit new search query
class ULSubmitSearchEvent extends ULEvent {
  final String searchQuery;

  ULSubmitSearchEvent({
    this.searchQuery,
  });

  @override
  List<Object> get props => [
        runtimeType,
        searchQuery,
      ];
}
