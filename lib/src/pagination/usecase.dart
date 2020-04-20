import '../common/usecase.dart';
import 'meta.dart';
import 'response.dart';

/// Unlimited list use case interface
abstract class PaginationRequestUseCase<M>
    extends AsyncUseCaseInterface<PaginationAsyncResponse<M>> {
  // pagination request meta with initial null value
  PaginationRequestMeta meta;

  @override
  Future<PaginationAsyncResponse<M>> send();
}
