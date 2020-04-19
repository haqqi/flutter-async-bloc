import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'response.dart';

/*********************************************/
/**************** Async event ****************/
/*********************************************/

/// Base async event
///
@immutable
abstract class AsyncEvent extends Equatable {
  const AsyncEvent();

  @override
  List<Object> get props => [
        runtimeType,
      ];
}

/// Event for resetting the state to init state
///
class AsyncResetEvent extends AsyncEvent {
  const AsyncResetEvent();
}

/// Async event start sending data or request
///
class AsyncSendEvent extends AsyncEvent {
  const AsyncSendEvent();
}

/// Async event done event, after receive the result from request. It
/// returns response either success or error
///
class AsyncDoneEvent<D> extends AsyncEvent {
  final AsyncResponse<D> response;

  const AsyncDoneEvent({
    @required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}
