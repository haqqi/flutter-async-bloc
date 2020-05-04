import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'event.dart';
import 'state.dart';

class AsyncFormBloc<F, R> extends Bloc<AsyncFormEvent, AsyncFormState<F>> {
  final F _form;

  AsyncFormBloc(F form)
      : assert(form != null),
        _form = form,
        super();

  @override
  AsyncFormState<F> get initialState => AsyncFormReady<F>(form: _form);

  @override
  @mustCallSuper
  Stream<AsyncFormState<F>> mapEventToState(AsyncFormEvent event) async* {
    if (event is AsyncFormSend && state is AsyncFormReady<F>) {
      // mark it as sending
      yield AsyncFormSending<F>(form: state.form);
    } else if (event is AsyncFormReceiveResponse<R> &&
        state is AsyncFormSending<F>) {
      // mark it as done
      yield AsyncFormDone<F, R>(
        form: state.form,
        response: event.response,
      );

      // change it back to ready
      yield AsyncFormReady<F>(form: state.form);
    }
  }
}
