import '../common/response.dart';

/// Representation of a form use case, with the return of [R] as [AsyncResponse]
/// It also contains [F] who hold form data.
abstract class FormSubmitUseCase<F, R> {
  Future<AsyncResponse<R>> send(F form);
}
