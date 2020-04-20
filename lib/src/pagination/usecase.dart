import '../common/usecase.dart';
import 'response.dart';

/// Unlimited list use case interface
abstract class PaginationRequestUseCase<M>
    extends AsyncUseCaseInterface<PaginationAsyncResponse<M>> {
  @override
  Future<PaginationAsyncResponse<M>> send();
}
