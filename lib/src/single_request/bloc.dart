import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

class SingleRequestBloc<R, U extends SingleRequestUseCase<R>>
    extends Bloc<SingleRequestEvent, SingleRequestState> {
  /// use case of fetching
  final U useCase;

  /// State for catching the availability. For example, after pop we don't
  /// do anything regarding unfinished response.
  bool _isAvailable = true;

  /// Clean result to display full page loading screen
  final bool clearResultOnRefresh;

  SingleRequestBloc({
    @required this.useCase,
    this.clearResultOnRefresh = true,
  })  : assert(useCase != null),
        super();

  @override
  SingleRequestState get initialState => SingleRequestInitState();

  @override
  Stream<SingleRequestState> mapEventToState(SingleRequestEvent event) async* {
    // if the event is fetching
    if (event is SingleRequestFetchEvent) {
      // catching previous result
      R previousResult;

      // if the previous state is done state
      if (state is SingleRequestDoneState<R> && !clearResultOnRefresh) {
        previousResult = (state as SingleRequestDoneState<R>).response.data;
      }

      yield SingleRequestFetchingState<R>(
        previousResult: previousResult,
      );

      AsyncResponse<R> response = await useCase.fetch();

      // if this bloc is unavailable anymore, no need to yield new state
      if (!_isAvailable) {
        return;
      }

      yield SingleRequestDoneState<R>(
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
