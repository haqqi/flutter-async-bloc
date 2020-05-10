import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/constant.dart';
import '../common/response.dart';
import 'response.dart';

/// Base [AsyncListData] for the state, so it can be extendable
class AsyncListData<M> extends ListBase<M> with EquatableMixin {
  /// Store the result
  final List<M> _data;

  AsyncListData({
    List<M> initialData,
  }) : _data = initialData ?? <M>[];

  @override
  int get length => _data.length;

  @override
  set length(int newLength) {
    _data.length = newLength;
  }

  @override
  M operator [](int index) {
    return _data[index];
  }

  @override
  void operator []=(int index, M value) {
    _data[index] = value;
  }

  /// Override of [EquatableMixin]
  @override
  List<Object> get props => [_data];
}

// base of list state
abstract class AsyncListState<M, LD extends AsyncListData<M>>
    extends Equatable {
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
class AsyncListReadyState<M, LD extends AsyncListData<M>>
    extends AsyncListState<M, LD> {
  const AsyncListReadyState({
    @required LD data,
    @required AsyncListStateMeta meta,
  }) : super.mustCall(list: data, meta: meta);
}

// Fetching list state
class AsyncListFetchingState<M, LD extends AsyncListData<M>>
    extends AsyncListState<M, LD> {
  const AsyncListFetchingState({
    @required LD data,
    @required AsyncListStateMeta meta,
  }) : super.mustCall(list: data, meta: meta);
}

class AsyncListProcessingResponseState<M, LD extends AsyncListData<M>,
    R extends AsyncListResponse<M>> extends AsyncListState<M, LD> {
  final AsyncResponse<R> response;

  const AsyncListProcessingResponseState({
    @required LD data,
    @required AsyncListStateMeta meta,
    @required AsyncResponse<R> this.response,
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
