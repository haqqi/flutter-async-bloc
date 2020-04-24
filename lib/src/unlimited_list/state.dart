import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/constant.dart';
import '../common/response.dart';

/// Unlimited state
@immutable
class UnlimitedListState<M> extends Equatable {
  // is fetching
  final bool isFetching;

  // error
  final AsyncError error;

  // resulted data
  final List<M> data;

  // current meta
  final UnlimitedListStateMeta meta;

  /// check if the response has data
  bool get hasData => data.length > 0;

  /// check if the response has error
  bool get hasError => error != null;

  // default constructor
  UnlimitedListState({
    List<M> data,
    UnlimitedListStateMeta meta,
    this.isFetching = false,
    this.error = null,
  })  : data = (data != null) ? data : List<M>(),
        meta = (meta != null) ? meta : UnlimitedListStateMeta();

  UnlimitedListState<M> copyWith({
    bool isFetching,
    AsyncError error,
    List<M> data,
    UnlimitedListStateMeta meta,
  }) {
    return UnlimitedListState<M>(
      isFetching: isFetching ?? this.isFetching,
      error: error ?? this.error,
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }

  @override
  List<Object> get props => [
        isFetching,
        error,
        data.length,
        meta,
      ];
}

/// Unlimited state meta
@immutable
class UnlimitedListStateMeta extends Equatable {
  // current page, start from 1
  final int currentPage;

  // per page request
  final int perPage;

  // fetched at mark
  final String fetchedAt;

  // search query
  final String searchQuery;

  // order by column name
  final String orderBy;

  // order direction
  final String sort;

  // has reached end
  final bool hasReachedEnd;

  UnlimitedListStateMeta({
    this.currentPage = 0, // start from page 0 (no fetching yet)
    this.perPage = 20,
    this.fetchedAt = '',
    this.searchQuery = '',
    this.orderBy = 'created_at',
    this.sort = Constant.sortDesc,
    this.hasReachedEnd = false,
  });

  UnlimitedListStateMeta copyWith({
    int currentPage,
    int perPage,
    String fetchedAt,
    String searchQuery,
    String orderBy,
    String sort,
    bool hasReachedEnd,
  }) {
    return UnlimitedListStateMeta(
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      searchQuery: searchQuery ?? this.searchQuery,
      orderBy: orderBy ?? this.orderBy,
      sort: sort ?? this.sort,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object> get props => [
        currentPage,
        perPage,
        searchQuery,
        fetchedAt,
        orderBy,
        sort,
        hasReachedEnd,
      ];
}
