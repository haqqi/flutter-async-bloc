import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FormSubmitEvent extends Equatable {
  const FormSubmitEvent();

  @override
  List<Object> get props => [
        runtimeType,
      ];
}

class FormSubmitSendEvent extends FormSubmitEvent {
  const FormSubmitSendEvent();
}
