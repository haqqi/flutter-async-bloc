import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

class SRBloc<R, U extends SRUseCase<R>> extends Bloc<SREvent, SRState> {
  /// use case of fetching
  final U useCase;

  /// State for catching the availability. For example, after pop we don't
  /// do anything regarding unfinished response.
  bool _isAvailable = true;

  /// whether refresh will clear the data
  final bool refreshClearData;

  SRBloc({
    @required this.useCase,
    this.refreshClearData = true,
  })  : assert(useCase != null),
        super();

  @override
  SRState get initialState => SRInitState();

  @override
  Stream<SRState> mapEventToState(SREvent event) async* {
    // if the event is fetching
    if (event is SRFetchEvent<R>) {
      yield SRFetchingState(
        previousResult: event.previousResult,
      );

      AsyncResponse<R> response = await useCase.fetch();

      // if this bloc is unavailable anymore, no need to yield new state
      if (!_isAvailable) {
        return;
      }

      yield SRDoneState(
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
