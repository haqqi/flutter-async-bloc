import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';
import '../common/usecase.dart';
import 'event.dart';
import 'state.dart';

/*********************************************/
/************ Async basic bloc ***************/
/*********************************************/

/// Basic async bloc that expect a [D] as success result
class AsyncBloc<D, U extends AsyncUseCaseInterface<D>>
    extends Bloc<AsyncEvent, AsyncState> {
  final U useCase;

  bool _available;

  /// Just constructor for logging
  AsyncBloc({
    @required this.useCase,
  })  : assert(useCase != null),
        super();

  /// Initial state with no data
  @override
  AsyncState get initialState {
    _available = true;

    return AsyncInitState();
  }

  // mapping process
  @override
  Stream<AsyncState> mapEventToState(AsyncEvent event) async* {
    // if send is fired
    if (event is AsyncSendEvent) {
      // Send the sending state signal
      yield AsyncSendingState();
    } else if (event is AsyncDoneEvent) {
      // Send the done state
      yield AsyncDoneState<D>(event.response);

      if (event.response.hasError) {
        // Send error state
        yield AsyncErrorState(event.response.error);
      } else {
        // Send success state
        yield AsyncSuccessState<D>(event.response.data);
      }
    } else if (event is AsyncResetEvent) {
      // yield reset first, then yield init
      yield AsyncResetState();
      // Init state again
      yield AsyncInitState();
    }
  }

  /// Simplify reset state
  void reset() async {
    add(AsyncResetEvent());
  }

  /// Send event to be called in the widget
  Future<void> send() async {
    // add the event for sending
    add(AsyncSendEvent());

    // create the completer for
    final Completer<void> completer = Completer<void>();

    // call the use case send
    useCase.send().then(
      // if it is success, call async done event with success response
      (D data) {
        if (_available) {
          add(AsyncDoneEvent<D>(
            response: AsyncResponse.success(data),
          ));
        }
      },
    ).catchError(
      // if there is error, call the done event with error response
      (error) {
        if (_available) {
          add(AsyncDoneEvent<D>(
            response: AsyncResponse.error(error),
          ));
        }
      },
      test: (e) => (e is AsyncError),
    ).whenComplete(() {
      completer.complete();
    });

    return completer.future;
  }

  @override
  Future<void> close() {
    _available = false;
    useCase?.dispose();
    return super.close();
  }
}

/*********************************************/
/***************** End of bloc ***************/
/*********************************************/
