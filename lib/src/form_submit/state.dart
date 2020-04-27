import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../common/response.dart';

/// Representation of a form state, with the return of [R] as [AsyncResponse]
/// It also contains [F] who hold form data.
@immutable
class FormSubmitState<F, R> extends Equatable {
//  /// Global key to handle the widget form state. Useful for handling validation
//  /// and submission.
//  ///
//  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//  /// Validate the form logic using form key or custom form validation
//  ///
//  @mustCallSuper
//  bool validate() {
//    // if form key is attached, and validation failed, just return false
//    if (formKey.currentState.mounted && !formKey.currentState.validate()) {
//      return false;
//    }
//
//    // save the state
//    formKey.currentState?.save();
//
//    // validate the form
//    return true;
//  }

  /// Initial form data
  final F formData;

  /// response once done
  final AsyncResponse<R> response;

  /// flag for sending
  final bool isSending;

  FormSubmitState._({
    this.formData,
    this.response = null,
    this.isSending = false,
  }) : assert(formData != null);

  FormSubmitState.init({
    @required F formData,
  }) : this._(
          formData: formData,
          isSending: false,
        );

  FormSubmitState<F, R> markSending() {
    return FormSubmitState<F, R>._(
      formData: formData,
      isSending: true,
      response: null,
    );
  }

  FormSubmitState<F, R> markDone(AsyncResponse<R> response) {
    return FormSubmitState<F, R>._(
      formData: formData,
      isSending: false,
      response: response,
    );
  }

  @override
  List<Object> get props => [
        response,
        isSending,
        formData,
      ];
}
