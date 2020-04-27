import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../common/response.dart';

/// Representation of a form state, with the return of T once the submission has
/// done. We reuse the [AsyncSnapshot] library from flutter
@immutable
abstract class FormSubmitState<Response> extends Equatable {
  /// response once done
  final AsyncResponse<Response> response;

  /// flag for sending
  final bool isSending;

  FormSubmitState(
    this.response,
    this.isSending,
  );

  /// Self return mark sending. Must change the isSending to true.
  FormSubmitState<Response> markSending();

  /// Self return mark success. Must change the isSending to false.
  FormSubmitState<Response> markDone(AsyncResponse<Response> response);
}
