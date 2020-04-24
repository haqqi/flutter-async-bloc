import 'package:equatable/equatable.dart';

// base event
abstract class UnlimitedListEvent extends Equatable {
  const UnlimitedListEvent();

  @override
  List<Object> get props => [];
}

// fetching, must bring the meta
class UnlimitedListFetchEvent extends UnlimitedListEvent {}

/// Refresh the page by using refresh indicator
class UnlimitedListRefreshEvent extends UnlimitedListEvent {}

/// Submit new search query
class UnlimitedListSearchEvent extends UnlimitedListEvent {
  final String searchQuery;

  UnlimitedListSearchEvent({
    this.searchQuery,
  });

  @override
  List<Object> get props => [
        runtimeType,
        searchQuery,
      ];
}
