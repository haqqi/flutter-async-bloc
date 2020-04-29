import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'event.dart';
import 'state.dart';

abstract class AsyncFormBloc<F, R>
    extends Bloc<AsyncFormEvent, AsyncFormState<F>> {
  @override
  AsyncFormState<F> get initialState;

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
