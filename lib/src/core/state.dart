import 'package:equatable/equatable.dart';

import 'response.dart';

/*********************************************/
/************ Async state bloc ***************/
/*********************************************/

/// Base async state
///
abstract class AsyncState extends Equatable {
  const AsyncState();

  @override
  List<Object> get props => [
        runtimeType,
      ];
}

/// Async initial state
///
class AsyncInitState extends AsyncState {
  const AsyncInitState();
}

/// Async sending state
///
class AsyncSendingState extends AsyncState {
  const AsyncSendingState();
}

/// Async done state
///
class AsyncDoneState<D> extends AsyncState {
  final AsyncResponse<D> response;

  const AsyncDoneState(this.response);

  @override
  List<Object> get props => [
        response,
      ];
}

/// Async initial state
///
class AsyncResetState extends AsyncState {
  const AsyncResetState();
}

/*********************************************/
/********* End of async state ****************/
/*********************************************/
