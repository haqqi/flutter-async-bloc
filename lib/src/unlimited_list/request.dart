import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'response.dart';
import 'state.dart';

abstract class ULUseCase<M> {
  /// Send the request and return the data of [D]
  Future<ULResponse<M>> fetch(ULRequestMeta meta);
}

class ULRequestMeta extends Equatable {
  final int page;
  final int perPage;
  final String fetchedAt;
  final String searchQuery;
  final String orderBy;
  final String sort;

  ULRequestMeta({
    @required this.page,
    @required this.perPage,
    @required this.fetchedAt,
    @required this.searchQuery,
    @required this.orderBy,
    @required this.sort,
  });

  ULRequestMeta.nextPage(ULStateMeta stateMeta)
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
