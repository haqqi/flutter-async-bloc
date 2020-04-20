import 'package:meta/meta.dart';

/// Use case interface that can be used as payload too.
/// This is mutable class that can be used to store some value.
/// So it is usable as form data too. Take a look at [FormSubmitUseCase]
///
abstract class AsyncUseCaseInterface<D> {
  /// Send the request and return the data of [D]
  Future<D> send();

  /// What to do when the use case is disposed. It is called in bloc disposer.
  ///
  @mustCallSuper
  void dispose() {}
}
