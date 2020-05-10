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
class AsyncListBloc<M, LD extends AsyncListData<M>,
        R extends AsyncListResponse<M>>
    extends Bloc<AsyncListEvent, AsyncListState<M, LD>> {
  final LD _data;

  AsyncListBloc({
    @required LD data,
  })  : assert(data != null),
        _data = data,
        super();

  @override
  AsyncListState<M, LD> get initialState => AsyncListReadyState<M, LD>(
        data: _data,
        meta: AsyncListStateMeta.create(),
      );

  @override
  Stream<AsyncListState<M, LD>> mapEventToState(AsyncListEvent event) async* {
    if (event is AsyncListFetchEvent) {
      yield AsyncListFetchingState<M, LD>(
        data: state.list,
        meta: state.meta,
      );
    } else if (event is AsyncListReceiveResponse<R> &&
        state is AsyncListFetchingState<M, LD>) {
      // temp state for adding
      yield AsyncListProcessingResponseState<M, LD, R>(
        data: state.list, // no change in list
        meta: state.meta, // no change in meta
        response: event.response, // add response if want to be used
      );

      // if the response has error, don't update the data
      if (event.response.hasError) {
        yield AsyncListReadyState<M, LD>(
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

        yield AsyncListReadyState<M, LD>(
          data: state.list..addAll(event.response.data.list),
          meta: state.meta,
        );
      }
    }
  }

  @override
  void onTransition(Transition<AsyncListEvent, AsyncListState<M, LD>> transition) {
    super.onTransition(transition);

    print(transition);
  }
}
