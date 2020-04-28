import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';
import 'event.dart';
import 'state.dart';
import 'usecase.dart';

/// [R] return type declaration of the use case
/// [F] form data representation
class FormSubmitBloc<F, R>
    extends Bloc<FormSubmitEvent, FormSubmitState<F, R>> {
  /// use case for sending the data
  final FormSubmitUseCase<F, R> useCase;

  /// just a flag to prevent state update
  bool _isAvailable = true;

  /// temporary form
  final F _form;

  FormSubmitBloc({
    @required this.useCase,
    @required F form,
  })  : assert(useCase != null),
        assert(form != null),
        _form = form,
        super();

  @override
  Future<void> close() {
    // mark that this is not available anymore
    _isAvailable = false;

    return super.close();
  }

  @override
  FormSubmitState<F, R> get initialState =>
      FormSubmitState<F, R>.init(formData: _form);

  @override
  @mustCallSuper
  Stream<FormSubmitState<F, R>> mapEventToState(FormSubmitEvent event) async* {
    if (event is FormSubmitSendEvent) {
      // yield sending first
      yield state.markSending();

      /// do the call
      AsyncResponse<R> result = await useCase.sendInternal(state.formData);

      if (!_isAvailable) {
        return;
      }

      // yield it has done
      yield state.markDone(result);
    }
  }
}
