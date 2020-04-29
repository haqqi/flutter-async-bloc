import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

/// base state
abstract class AsyncFormState<F> extends Equatable {
  //. the payload
  final F form;

  const AsyncFormState({
    @required this.form,
  });

  @override
  List<Object> get props => [form];
}

class AsyncFormReady<F> extends AsyncFormState<F> {
  const AsyncFormReady({
    @required F form,
  }) : super(form: form);
}

class AsyncFormSending<F> extends AsyncFormState<F> {
  const AsyncFormSending({
    @required F form,
  }) : super(form: form);
}

class AsyncFormDone<F, R> extends AsyncFormState<F> {
  final AsyncResponse<R> response;

  AsyncFormDone({
    F form,
    this.response,
  }) : super(form: form);

  @override
  List<Object> get props => [form, response];
}
