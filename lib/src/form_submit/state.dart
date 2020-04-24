import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

// base state
@immutable
abstract class FormSubmitState extends Equatable {
  const FormSubmitState();

  @override
  List<Object> get props => [];
}

@immutable
class FormSubmitInitState extends FormSubmitState {
  const FormSubmitInitState();
}

@immutable
class FormSubmitSendingState extends FormSubmitState {
  const FormSubmitSendingState();
}

@immutable
class FormSubmitDoneState<R> extends FormSubmitState {
  final AsyncResponse<R> response;

  const FormSubmitDoneState({
    @required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}
