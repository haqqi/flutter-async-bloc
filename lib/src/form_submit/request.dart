import 'package:flutter/widgets.dart';

import '../common/response.dart';

abstract class FSUseCase<R> {
  /// Global key to handle the form state. Useful for handling validation
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

  Future<AsyncResponse<R>> send() async {
    // validate, if false, throw async error that show the
    if (!validate()) {
      return AsyncResponse<R>.error(
        AsyncError(
          id: 'Form.Validate',
          message: 'Invalid data supplied',
          code: -1,
        ),
      );
    }

    return await sendForm();
  }

  /// Real process of send form, that return the [AsyncResponse] of [R] as the response.
  Future<AsyncResponse<R>> sendForm();
}
