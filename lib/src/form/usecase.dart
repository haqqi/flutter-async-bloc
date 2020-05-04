import '../common/response.dart';

abstract class AsyncFormUseCase<F, R> {
  Future<AsyncResponse<R>> send(F form);
}
