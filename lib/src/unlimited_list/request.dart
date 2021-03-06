import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'response.dart';
import 'state.dart';

abstract class UnlimitedListUseCase<M> {
  /// Send the request and return the data of [D]
  Future<UnlimitedListResponse<M>> fetch(UnlimitedListRequestMeta meta);
}

class UnlimitedListRequestMeta extends Equatable {
  final int page;
  final int perPage;
  final String fetchedAt;
  final String searchQuery;
  final String orderBy;
  final String sort;

  UnlimitedListRequestMeta({
    @required this.page,
    @required this.perPage,
    @required this.fetchedAt,
    @required this.searchQuery,
    @required this.orderBy,
    @required this.sort,
  });

  UnlimitedListRequestMeta.nextPage(UnlimitedListStateMeta stateMeta)
      : this(
          page: stateMeta.currentPage + 1,
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
