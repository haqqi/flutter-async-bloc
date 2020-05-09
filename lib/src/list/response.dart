import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Async list response that can be extended
class AsyncListResponse<M> with EquatableMixin {
  // real data
  final List<M> list;

  // response from server
  final int totalPage;

  // total item
  final int totalItem;

  // fetched at
  final String fetchedAt;

  AsyncListResponse.create({
    @required this.list,
    @required this.totalPage,
    @required this.totalItem,
    @required this.fetchedAt,
  });

  @override
  List<Object> get props => [
        list,
        totalPage,
        totalItem,
        fetchedAt,
      ];
}

