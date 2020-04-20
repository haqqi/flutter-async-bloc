import 'package:meta/meta.dart';

import '../bloc/async.dart';
import 'response.dart';
import 'usecase.dart';

class UnlimitedListBloc<M, U extends PaginationRequestUseCase<M>>
    extends AsyncBloc<PaginationAsyncResponse<M>, U> {
  // unlimited list bloc
  UnlimitedListBloc({
    @required U useCase,
  })  : assert(useCase != null),
        super(useCase: useCase);
}
