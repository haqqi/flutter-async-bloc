import '../common/response.dart';
import 'state.dart';

/// Interface for async form use case
abstract class FormSubmitUseCase<Response,
    Form extends FormSubmitState<Response>> {
  Future<AsyncResponse<Response>> send(Form form);
}
