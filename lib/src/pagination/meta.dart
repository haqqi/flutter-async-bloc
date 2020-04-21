import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Meta for unlimited list request. Will be in the use case for the getter.
///
@immutable
class PaginationRequestMeta extends Equatable {
  static const String sortAsc = "asc";
  static const String sortDesc = "desc";

  final int page;
  final int perPage;
  final String fetchedAt;
  final String searchQuery;
  final String orderBy;
  final String sort;

  PaginationRequestMeta({
    this.page = 1,
    this.perPage = 20,
    this.fetchedAt = '',
    this.searchQuery = '',
    this.orderBy = '',
    this.sort = '',
  });

  PaginationRequestMeta copyWith({
    int page,
    int perPage,
    String fetchedAt,
    bool hasReachedEnd,
    String searchQuery,
    String orderBy,
    String sort,
  }) {
    return PaginationRequestMeta(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      searchQuery: searchQuery ?? this.searchQuery,
      orderBy: orderBy ?? this.orderBy,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object> get props => [
        page,
        perPage,
        fetchedAt,
        searchQuery,
        orderBy,
        sort,
      ];
}

@immutable
class PaginationResponseMeta extends Equatable {
  final int totalPage;
  final int totalItem;
  final String fetchedAt;

  PaginationResponseMeta({
    this.totalPage,
    this.totalItem,
    this.fetchedAt,
  });

  @override
  List<Object> get props => [
        totalPage,
        totalItem,
        fetchedAt,
      ];
}
