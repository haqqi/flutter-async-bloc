import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

@immutable
abstract class SRState extends Equatable {
  const SRState();

  @override
  List<Object> get props => [
        runtimeType,
      ];
}

@immutable
class SRInitState extends SRState {
  const SRInitState();
}

@immutable
class SRFetchingState<R> extends SRState {
  final R previousResult;

  const SRFetchingState({
    this.previousResult,
  });

  bool get hasPreviousResult => previousResult != null;

  @override
  List<Object> get props => [
        previousResult,
      ];
}

@immutable
class SRDoneState<R> extends SRState {
  final AsyncResponse<R> response;

  const SRDoneState({
    @required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}
