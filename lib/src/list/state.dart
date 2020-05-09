import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/constant.dart';
import 'response.dart';

/// Base [ListData] for the state, so it can be extendable
class ListData<M> extends ListBase<M> with EquatableMixin {
  /// Store the result
  final List<M> _data;

  ListData({
    @required List<M> initialData,
  }) : _data = initialData;

  /// Override of [EquatableMixin]
  @override
  List<Object> get props => [_data];

  @override
  int length;

  @override
  M operator [](int index) {
    return _data[index];
  }

  @override
  void operator []=(int index, M value) {
    _data[index] = value;
  }
}

// base of list state
abstract class AsyncListState<LD extends ListData<dynamic>> extends Equatable {
  /// Store the result
  final LD list;

  /// Store list meta
  final AsyncListStateMeta meta;

  const AsyncListState.mustCall({
    @required this.list,
    @required this.meta,
  })  : assert(list != null),
        assert(meta != null);

  @override
  List<Object> get props => [
        list,
        meta,
      ];
}

// Ready to send or manipulate list state
class AsyncListReadyState<LD extends ListData<dynamic>>
    extends AsyncListState<LD> {
  const AsyncListReadyState({
    @required LD data,
    @required AsyncListStateMeta meta,
  }) : super.mustCall(list: data, meta: meta);
}

// Fetching list state
class AsyncListFetchingState<LD extends ListData<dynamic>>
    extends AsyncListState<LD> {
  const AsyncListFetchingState({
    @required LD data,
    @required AsyncListStateMeta meta,
  }) : super.mustCall(list: data, meta: meta);
}

class AsyncListAddingDataState<LD extends ListData<dynamic>,
    R extends AsyncListResponse<dynamic>> extends AsyncListState<LD> {
  final R response;

  const AsyncListAddingDataState({
    @required LD data,
    @required AsyncListStateMeta meta,
    @required R this.response,
  }) : super.mustCall(list: data, meta: meta);
}

// The meta for the state
class AsyncListStateMeta with EquatableMixin {
  // current page, start from 1
  int currentPage;

  // per page request
  int perPage;

  // fetched at mark
  String fetchedAt;

  // search query
  String searchQuery;

  // order by column name
  String orderBy;

  // order direction
  String sort;

  // has reached end
  bool hasReachedEnd;

  AsyncListStateMeta.create({
    this.currentPage = 0, // start from page 0 (no fetching yet)
    this.perPage = 20,
    this.fetchedAt = '',
    this.searchQuery = '',
    this.orderBy = 'created_at',
    this.sort = Constant.sortDesc,
    this.hasReachedEnd = false,
  });

  @override
  List<Object> get props => [
        currentPage,
        perPage,
        fetchedAt,
        searchQuery,
        orderBy,
        sort,
        hasReachedEnd,
      ];
}
