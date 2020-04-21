import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

/// Unlimited list response with list of data and meta
@immutable
class UnlimitedListResponse<M> extends AsyncResponse<List<M>> {
  /// the meta
  final UnlimitedListResponseMeta meta;

  UnlimitedListResponse.success({
    @required List<M> data,
    @required this.meta,
  }) : super.success(data);

  UnlimitedListResponse.error({
    @required AsyncError error,
  })  : meta = null,
        super.error(error);
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
