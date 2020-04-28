import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../common/response.dart';

/// Representation of a form state, with the return of [R] as [AsyncResponse]
/// It also contains [F] who hold form data.
@immutable
class FormSubmitState<F, R> extends Equatable {
  /// Initial form data
  final F formData;

  /// response once done
  final AsyncResponse<R> response;

  /// flag for sending
  final bool isSending;

  /// just a flag for static rebuild, since the formData cannot be changed
  final int _rebuildCount;

  FormSubmitState._({
    this.formData,
    this.response = null,
    this.isSending = false,
    int rebuildCount = 0,
  })  : assert(formData != null),
        _rebuildCount = rebuildCount;

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
      rebuildCount: _rebuildCount,
    );
  }

  FormSubmitState<F, R> markDone(AsyncResponse<R> response) {
    return FormSubmitState<F, R>._(
      formData: formData,
      isSending: false,
      response: response,
      rebuildCount: _rebuildCount,
    );
  }

  FormSubmitState<F, R> rebuild() {
    return FormSubmitState<F, R>._(
      formData: formData,
      isSending: false,
      response: null,
      rebuildCount: _rebuildCount + 1,
    );
  }

  @override
  List<Object> get props => [
        response,
        isSending,
        formData,
        _rebuildCount,
      ];

  @override
  String toString() {
    String text = '';

    if (isSending) {
      text += 'Sending State';
    } else {
      if (response == null) {
        text += 'Waiting State >> ' + formData.toString();
      } else {
        text += 'Done State >> ' + (response.hasError ? 'error' : 'success');
      }
    }

    return text;
  }
}
