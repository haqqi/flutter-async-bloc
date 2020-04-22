import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';
import '../consts.dart';

/// Unlimited state
@immutable
class ULState<M> extends Equatable {
  // is fetching
  final bool isFetching;

  // error
  final AsyncError error;

  // resulted data
  final List<M> data;

  // current meta
  final ULStateMeta meta;

  // default constructor
  ULState({
    List<M> data,
    ULStateMeta meta,
    this.isFetching = false,
    this.error = null,
  })  : data = (data != null) ? data : List<M>(),
        meta = (meta != null) ? meta : ULStateMeta.init();

  @override
  List<Object> get props => [];
}

/// Unlimited state meta
@immutable
class ULStateMeta extends Equatable {
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

  ULStateMeta._({
    this.currentPage = 1,
    this.perPage = 20,
    this.fetchedAt = '',
    this.searchQuery = '',
    this.orderBy = 'created_at',
    this.sort = Constant.sortDesc,
  });

  ULStateMeta.init({
    int perPage,
    String searchQuery,
    String orderBy,
    String sort,
  }) : this._(
          perPage: perPage,
          searchQuery: searchQuery,
          orderBy: orderBy,
          sort: sort,
        );

  @override
  List<Object> get props => [
        currentPage,
        perPage,
        searchQuery,
        fetchedAt,
        orderBy,
        sort,
      ];
}
