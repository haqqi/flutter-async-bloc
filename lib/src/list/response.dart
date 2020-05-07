import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Async list response that must be extended
abstract class AsyncListResponse<M> with EquatableMixin {
  // real data
  final List<M> data;

  // response from server
  final int totalPage;

  // total item
  final int totalItem;

  // fetched at
  final String fetchedAt;

  AsyncListResponse.create({
    @required this.data,
    @required this.totalPage,
    @required this.totalItem,
    @required this.fetchedAt,
  });

  @override
  List<Object> get props => [
        data,
        totalPage,
        totalItem,
        fetchedAt,
      ];
}

