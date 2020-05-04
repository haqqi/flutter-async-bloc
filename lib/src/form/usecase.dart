import 'package:meta/meta.dart';

import '../common/response.dart';
import 'mixin.dart';

abstract class AsyncFormUseCase<F, R> {
  // use case id
  final String _id;

  AsyncFormUseCase({
    @required String useCaseId,
  })  : assert(useCaseId != null),
        _id = useCaseId;

  Future<AsyncResponse<R>> send(F form);

  // real sending with validation
  Future<AsyncResponse<R>> validateAndSend(F form) async {
    if (form is FormWithKeyMixin && !form.validate()) {
      return AsyncResponse<R>.error(AsyncError(
        id: _id,
        code: 400,
        message: 'Invalid form data supplied',
      ));
    }

    return await send(form);
  }
}
