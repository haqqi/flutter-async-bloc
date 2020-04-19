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
class AsyncDoneState extends AsyncState {
  const AsyncDoneState();
}

/// Async success state with data of [D]
///
class AsyncSuccessState<D> extends AsyncState {
  final D data;

  AsyncSuccessState(this.data);

  @override
  List<Object> get props => [
        data,
      ];
}

/// Async error state with error message of [AsyncError]
class AsyncErrorState extends AsyncState {
  final AsyncError error;

  AsyncErrorState(this.error);

  @override
  List<Object> get props => [
        error,
      ];
}

/*********************************************/
/********* End of async state ****************/
/*********************************************/
