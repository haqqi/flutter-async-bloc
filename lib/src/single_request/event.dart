import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SingleRequestEvent extends Equatable {
  const SingleRequestEvent();

  @override
  List<Object> get props => [];
}

@immutable
class SingleRequestFetchEvent extends SingleRequestEvent {
  const SingleRequestFetchEvent();
}
