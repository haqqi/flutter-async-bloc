import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SREvent extends Equatable {
  const SREvent();

  @override
  List<Object> get props => [
        runtimeType,
      ];
}

@immutable
class SRFetchEvent<R> extends SREvent {
  final R previousResult;

  const SRFetchEvent({
    this.previousResult,
  });

  bool get hasPreviousResult => previousResult != null;

  @override
  List<Object> get props => [
        previousResult,
      ];
}
