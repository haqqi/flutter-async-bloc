import '../common/response.dart';

abstract class SingleRequestUseCase<R> {
  Future<AsyncResponse<R>> fetch();
}
