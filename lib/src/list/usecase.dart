import 'package:meta/meta.dart';

import '../common/response.dart';
import 'request.dart';
import 'response.dart';
import 'state.dart';

abstract class AsyncListUseCase<M, LD extends AsyncListData<M>,
    R extends AsyncListResponse<dynamic>> {
  final String useCaseId;

  AsyncListUseCase.mustCall({
    @required this.useCaseId,
  }) : assert(useCaseId != null);

  /// Fetch function that must provide request meta, but can also provide list
  /// data if needed
  Future<AsyncResponse<R>> fetch(
    AsyncListRequestMeta requestMeta, [
    LD listData,
  ]);
}
