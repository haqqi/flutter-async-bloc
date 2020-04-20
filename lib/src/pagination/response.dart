import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'meta.dart';

/// Unlimited list response with list of data and meta
@immutable
class PaginationAsyncResponse<M> extends Equatable {
  /// the meta
  final PaginationResponseMeta meta;

  /// the result
  final List<M> result;

  PaginationAsyncResponse({
    this.meta,
    this.result,
  });

  @override
  List<Object> get props => [
        meta,
        result,
      ];
}
