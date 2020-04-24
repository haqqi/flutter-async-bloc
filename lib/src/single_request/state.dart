import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

@immutable
abstract class SingleRequestState extends Equatable {
  const SingleRequestState();

  @override
  List<Object> get props => [];
}

@immutable
class SingleRequestInitState extends SingleRequestState {
  const SingleRequestInitState();
}

@immutable
class SingleRequestFetchingState<R> extends SingleRequestState {
  final R previousResult;

  const SingleRequestFetchingState({
    this.previousResult,
  });

  bool get hasPreviousResult => previousResult != null;

  @override
  List<Object> get props => [
        previousResult,
      ];
}

@immutable
class SingleRequestDoneState<R> extends SingleRequestState {
  final AsyncResponse<R> response;

  const SingleRequestDoneState({
    @required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}
