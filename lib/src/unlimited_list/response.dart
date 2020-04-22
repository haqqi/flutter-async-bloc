import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

/// Unlimited list response with list of data and meta
@immutable
class ULResponse<M> extends AsyncResponse<List<M>> {
  /// the meta
  final ULResponseMeta meta;

  ULResponse.success({
    @required List<M> data,
    @required this.meta,
  }) : super.success(data);

  ULResponse.error({
    @required AsyncError error,
  })  : meta = null,
        super.error(error);
}

@immutable
class ULResponseMeta extends Equatable {
  // response from server
  final int totalPage;

  // total item
  final int totalItem;

  // fetched at
  final String fetchedAt;

  ULResponseMeta({
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
