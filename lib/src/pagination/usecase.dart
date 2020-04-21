import 'package:meta/meta.dart';

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

  /// Set first page without changing the
  void setFirstPage() {
    meta = meta.copyWith(
      page: 1,
      fetchedAt: '',
    );
  }

  /// Set search query and also reset to first page
  void setSearchQuery(String text) {
    meta = meta.copyWith(
      searchQuery: text,
    );
    setFirstPage();
  }

  void setNextRequest({
    @required String fetchedAt,
    @required int totalPage,
  }) {
    meta = meta.copyWith(
      // if has reached end, why should add page
      page: meta.page + (totalPage > meta.page ? 1 : 0),
      fetchedAt: fetchedAt,
    );
  }
}
