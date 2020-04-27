import 'package:flutter/widgets.dart';

import '../common/response.dart';

/// Representation of a form use case, with the return of [R] as [AsyncResponse]
/// It also contains [F] who hold form data.
abstract class FormSubmitUseCase<F, R> {
  //  /// Global key to handle the widget form state. Useful for handling validation
  /// and submission.
  ///
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Validate the form logic using form key or custom form validation
  ///
  @mustCallSuper
  bool validate() {
    // if form key is attached, and validation failed, just return false
    if (formKey.currentState != null && !formKey.currentState.validate()) {
      return false;
    }

    // save the state
    formKey.currentState?.save();

    // validate the form
    return true;
  }

  Future<AsyncResponse<R>> sendInternal(F form) async {
    // validate locally, if false, throw async error that show the
    if (!validate()) {
      return AsyncResponse<R>.error(
        AsyncError(
          id: 'Form.Validate',
          message: 'Invalid data supplied',
          code: -1,
        ),
      );
    }

    return await send(form);
  }

  Future<AsyncResponse<R>> send(F form);
}
