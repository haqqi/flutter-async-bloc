import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'state.dart';

abstract class AsyncListRequest {
  final AsyncListRequestMeta meta;

  AsyncListRequest(this.meta) : assert(meta != null);
}

/// Base async list request
class BasicAsyncListRequest extends AsyncListRequest {
  BasicAsyncListRequest({
    @required AsyncListRequestMeta meta,
  })  : assert(meta != null),
        super(meta);
}

/// List request meta
class AsyncListRequestMeta extends Equatable {
  final int page;
  final int perPage;
  final String fetchedAt;
  final String searchQuery;
  final String orderBy;
  final String sort;

  AsyncListRequestMeta({
    @required this.page,
    @required this.perPage,
    @required this.fetchedAt,
    @required this.searchQuery,
    @required this.orderBy,
    @required this.sort,
  });

  AsyncListRequestMeta.nextPage(AsyncListStateMeta stateMeta)
      : this(
          page: stateMeta.currentPage + 1,
          perPage: stateMeta.perPage,
          fetchedAt: stateMeta.fetchedAt,
          searchQuery: stateMeta.searchQuery,
          orderBy: stateMeta.orderBy,
          sort: stateMeta.sort,
        );

  AsyncListRequestMeta.refresh(AsyncListStateMeta stateMeta)
      : this(
          page: 1,
          perPage: stateMeta.perPage,
          fetchedAt: stateMeta.fetchedAt,
          searchQuery: stateMeta.searchQuery,
          orderBy: stateMeta.orderBy,
          sort: stateMeta.sort,
        );

  @override
  List<Object> get props => [
        page,
        perPage,
        searchQuery,
        fetchedAt,
        orderBy,
        sort,
      ];
}
