import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FSEvent extends Equatable {
  const FSEvent();

  @override
  List<Object> get props => [
        runtimeType,
      ];
}

class FSSendEvent extends FSEvent {
  const FSSendEvent();
}
