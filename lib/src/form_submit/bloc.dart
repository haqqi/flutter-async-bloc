import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

class FormSubmitBloc<R, U extends FormSubmitUseCase<R>> extends Bloc<FormSubmitEvent, FormSubmitState> {
  // use case of form submit
  final U useCase;

  /// State for catching the availability. For example, after pop we don't
  /// do anything regarding unfinished response.
  bool _isAvailable = true;

  FormSubmitBloc({
    @required this.useCase,
  })  : assert(useCase != null),
        super();

  @override
  FormSubmitState get initialState => FormSubmitInitState();

  @override
  Stream<FormSubmitState> mapEventToState(FormSubmitEvent event) async* {
    if (event is FormSubmitSendEvent) {
      yield FormSubmitSendingState();

      AsyncResponse<R> response = await useCase.send();

      // if this bloc is unavailable anymore, no need to yield new state
      if (!_isAvailable) {
        return;
      }

      yield FormSubmitDoneState<R>(
        response: response,
      );
    }
  }

  @override
  Future<void> close() {
    // mark that this is not available anymore
    _isAvailable = false;

    return super.close();
  }
}
