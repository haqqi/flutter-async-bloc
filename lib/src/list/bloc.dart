import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'event.dart';
import 'response.dart';
import 'state.dart';

/// Basic async list bloc with default event:
/// - Fetch request
/// - Receive response
/// - Init search submission
/// - Reset list / refresh
class AsyncListBloc<LD extends ListData<dynamic>,
        R extends AsyncListResponse<dynamic>>
    extends Bloc<AsyncListEvent, AsyncListState<LD>> {
  final LD _data;

  AsyncListBloc({
    @required LD data,
  })  : assert(data != null),
        _data = data,
        super();

  @override
  AsyncListState<LD> get initialState => AsyncListReadyState<LD>(
        data: _data,
        meta: AsyncListStateMeta.create(),
      );

  @override
  Stream<AsyncListState<LD>> mapEventToState(AsyncListEvent event) async* {
    if (event is AsyncListFetchEvent) {
      yield AsyncListFetchingState<LD>(
        data: state.list,
        meta: state.meta,
      );
    } else if (event is AsyncListReceiveResponse<R> &&
        state is AsyncListFetchingState<LD>) {
      // temp state for adding
      yield AsyncListAddingDataState<LD, R>(
        data: state.list, // no change in list
        meta: state.meta, // no change in meta
        response: event.response.data, // add response if want to be used
      );

      // if the response has error, don't update the data
      if (event.response.hasError) {
        yield AsyncListReadyState<LD>(
          data: state.list,
          meta: state.meta,
        );
      } else {
        // Update the data and meta by adding 1 page
        final int currentPage = state.meta.currentPage + 1;

        state.meta.currentPage = currentPage;
        state.meta.fetchedAt = event.response.data.fetchedAt;
        state.meta.hasReachedEnd =
            (currentPage == event.response.data.totalPage);

        AsyncListReadyState<LD>(
          data: state.list..addAll(event.response.data.list),
          meta: state.meta,
        );
      }
    }
  }
}
