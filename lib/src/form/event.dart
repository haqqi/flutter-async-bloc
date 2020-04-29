import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

abstract class AsyncFormEvent extends Equatable {
  const AsyncFormEvent();

  @override
  List<Object> get props => [];
}

/// Send event
class AsyncFormSend extends AsyncFormEvent {
  const AsyncFormSend();
}

class AsyncFormReceiveResponse<R> extends AsyncFormEvent {
  final AsyncResponse<R> response;

  AsyncFormReceiveResponse({
    @required this.response,
  });

  @override
  List<Object> get props => [response];
}
