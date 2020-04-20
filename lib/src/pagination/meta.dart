import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Meta for unlimited list request. Will be in the use case for the getter.
///
@immutable
class PaginationRequestMeta extends Equatable {
  final int page;
  final int perPage;
  final String fetchedAt;
  final bool hasReachedEnd;
  final String searchQuery;

  PaginationRequestMeta({
    this.page = 1,
    this.perPage = 20,
    this.fetchedAt = '',
    this.hasReachedEnd = false,
    this.searchQuery = '',
  });

  PaginationRequestMeta copyWith({
    int page,
    int perPage,
    String fetchedAt,
    bool hasReachedEnd,
    String searchQuery,
  }) {
    return PaginationRequestMeta(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
        page,
        perPage,
        fetchedAt,
        hasReachedEnd,
        searchQuery,
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
