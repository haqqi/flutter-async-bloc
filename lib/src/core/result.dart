import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Async error object that holds [code] and [message]
///
@immutable
class AsyncError extends Equatable {
  /// Any kind of id, such as `auth.login.form`
  final String id;

  /// Any kind of code, such as `400`
  final int code;

  /// Any kind of message
  final String message;

  /// async error object for default error
  const AsyncError({
    @required this.id,
    @required this.message,
    this.code = 0,
  }) : assert(message != null);

  @override
  List<Object> get props => [
        id,
        code,
        message,
      ];
}

/// Async response, that can contains data or error
/// Any data can be assigned in generic [D] type
///
@immutable
class AsyncResponse<D> extends Equatable {
  /// Data response
  final D data;

  /// Error response
  final AsyncError error;

  /// Prevent to make it extendable without calling super
  const AsyncResponse._(this.data, this.error);

  /// success constructor
  const AsyncResponse.success(D data) : this._(data, null);

  /// Error constructor
  const AsyncResponse.error(AsyncError error) : this._(null, error);

  /// check if the response has data
  bool get hasData => data != null;

  /// check if the response has error
  bool get hasError => error != null;

  @override
  List<Object> get props => [
        data,
        error,
      ];
}
