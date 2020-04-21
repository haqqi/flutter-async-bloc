import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Unlimited list response with list of data and meta
@immutable
class UnlimitedListResponse<M> extends Equatable {
  /// the meta
  final UnlimitedListResponseMeta meta;

  /// the result
  final List<M> result;

  UnlimitedListResponse({
    this.meta,
    this.result,
  });

  @override
  List<Object> get props => [
        meta,
        result,
      ];
}

@immutable
class UnlimitedListResponseMeta extends Equatable {
  // response from server
  final int totalPage;

  // total item
  final int totalItem;

  // fetched at
  final String fetchedAt;

  UnlimitedListResponseMeta({
    @required this.totalPage,
    @required this.totalItem,
    @required this.fetchedAt,
  });

  @override
  List<Object> get props => [
        totalPage,
        totalItem,
        fetchedAt,
      ];
}
