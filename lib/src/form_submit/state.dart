import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../common/response.dart';

// base state
@immutable
abstract class FSState extends Equatable {
  const FSState();

  @override
  List<Object> get props => [];
}

@immutable
class FSInitState extends FSState {
  const FSInitState();
}

@immutable
class FSSendingState extends FSState {
  final bool blocking;

  FSSendingState({
    this.blocking,
  });

  @override
  List<Object> get props => [
        blocking,
      ];
}

@immutable
class FSDoneState<R> extends FSState {
  final AsyncResponse<R> response;

  const FSDoneState({
    @required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}
