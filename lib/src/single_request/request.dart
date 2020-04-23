import '../common/response.dart';

abstract class SRUseCase<R> {
  Future<AsyncResponse<R>> fetch();
}
