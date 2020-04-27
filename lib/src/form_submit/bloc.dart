import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';
import 'event.dart';
import 'state.dart';
import 'usecase.dart';

/// [Response] return type declaration of the use case
/// [State] state type declaration
abstract class FormSubmitBloc<Response, State extends FormSubmitState<Response>>
    extends Bloc<FormSubmitEvent, State> {
  /// use case for sending the data
  final FormSubmitUseCase<Response, State> useCase;

  /// just a flag to prevent state update
  bool _isAvailable = true;

  FormSubmitBloc(this.useCase);

  @override
  Future<void> close() {
    // mark that this is not available anymore
    _isAvailable = false;

    return super.close();
  }

  @override
  State get initialState;

  @override
  @mustCallSuper
  Stream<State> mapEventToState(FormSubmitEvent event) async* {
    if (event is FormSubmitSendEvent) {
      // yield sending first
      yield state.markSending();

      /// do the call
      AsyncResponse<Response> result = await useCase.send(state);

      if (!_isAvailable) {
        return;
      }

      // yield it has done
      yield state.markDone(result);

      // do nothing later
      return;
    }
  }
}
