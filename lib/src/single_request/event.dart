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
class SRFetchEvent extends SREvent {
  const SRFetchEvent();
}
