import 'package:meta/meta.dart';

import '../common/response.dart';
import 'request.dart';
import 'response.dart';

abstract class AsyncListUseCase<F extends AsyncListRequest,
    R extends AsyncListResponse<dynamic>> {
  final String useCaseId;

  AsyncListUseCase.mustCall({
    @required this.useCaseId,
  }) : assert(useCaseId != null);

  Future<AsyncResponse<R>> fetch(F listRequest);
}
