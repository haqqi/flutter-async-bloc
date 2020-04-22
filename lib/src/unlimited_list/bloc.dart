import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'event.dart';
import 'request.dart';
import 'response.dart';
import "state.dart";

class ULBloc<M> extends Bloc<ULEvent, ULState<M>> {
  final ULUseCase<M> useCase;

  // state for catching the availability
  bool _isAvailable = true;

  ULBloc({
    @required this.useCase,
  })  : assert(useCase != null),
        super();

  @override
  ULState<M> get initialState => ULState<M>();

  @override
  Stream<ULState<M>> mapEventToState(ULEvent event) async* {
    if (event is ULFetchEvent) {
      // pipe next page fetching
      yield* _fetchNextPage();
    } else if (event is ULRefreshEvent) {
      // yield reset data first
      yield state.copyWith(
        data: state.data..clear(),
        meta: ULStateMeta.init(
          perPage: state.meta.perPage,
          searchQuery: state.meta.searchQuery,
          orderBy: state.meta.orderBy,
          sort: state.meta.orderBy,
        ),
      );
      // pipe next page fetching
      yield* _fetchNextPage();
    } else if (event is ULSubmitSearchEvent) {
      // yield reset data first
      yield state.copyWith(
        data: state.data..clear(), // clear the data
        meta: ULStateMeta.init(
          perPage: state.meta.perPage,
          searchQuery: event.searchQuery, // change the search query
          orderBy: state.meta.orderBy,
          sort: state.meta.orderBy,
        ),
      );
      // pipe next page fetching
      yield* _fetchNextPage();
    }
  }

  // fetch next page
  Stream<ULState<M>> _fetchNextPage() async* {
    // yield is fetching
    yield state.copyWith(
      isFetching: true,
      error: null, // reset the error
    );

    // fetch the response
    ULResponse<M> response = await useCase.fetch(
      ULRequestMeta.nextPage(
        state.meta,
      ),
    );

    // if this bloc is unavailable anymore, no need to yield new state
    if (!_isAvailable) {
      return;
    }

    if (response.hasError) {
      // add the error
      yield state.copyWith(
        isFetching: false,
        error: response.error,
      );
    } else {
      // new current page
      final int currentPage = state.meta.currentPage + 1;

      yield state.copyWith(
        isFetching: false,
        data: state.data..addAll(response.data), // append the data
        meta: state.meta.copyWith(
          fetchedAt: response.meta.fetchedAt,
          currentPage: currentPage,
          hasReachedEnd: currentPage == response.meta.totalPage,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _isAvailable = false;

    return super.close();
  }
}
