import 'package:equatable/equatable.dart';
import 'response.dart';
import '../common/response.dart';
import 'package:meta/meta.dart';

// base event
abstract class AsyncListEvent extends Equatable {
  const AsyncListEvent();

  @override
  List<Object> get props => [];
}

// fetching, must bring the meta
class AsyncListFetchEvent extends AsyncListEvent {
  const AsyncListFetchEvent();
}

// The response of this receive event should be a child of async list response
class AsyncListReceiveResponse<R extends AsyncListResponse<dynamic>>
    extends AsyncListEvent {
  final AsyncResponse<R> response;

  const AsyncListReceiveResponse({
    @required this.response,
  });

  @override
  List<Object> get props => [response];
}

class AsyncListResetEvent extends AsyncListEvent {}
