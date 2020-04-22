import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'event.dart';
import 'request.dart';
import 'response.dart';
import "state.dart";

class ULBloc<M, U extends ULUseCase<M>> extends Bloc<ULEvent, ULState<M>> {
  // use case of fetching
  final U useCase;

  final ScrollController scrollController = ScrollController();

  /// State for catching the availability. For example, after pop we don't
  /// do anything regarding unfinished response.
  bool _isAvailable = true;

  ULBloc({
    @required this.useCase,
  })  : assert(useCase != null),
        super() {
    // add listener to scroll controller
    scrollController.addListener(_onScroll);
  }

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
        meta: ULStateMeta().copyWith(
          perPage: state.meta.perPage,
          searchQuery: state.meta.searchQuery,
          orderBy: state.meta.orderBy,
          sort: state.meta.sort,
        ),
      );
      // pipe next page fetching
      yield* _fetchNextPage();
    } else if (event is ULSubmitSearchEvent) {
      // yield reset data first
      yield state.copyWith(
        data: state.data..clear(), // clear the data
        meta: ULStateMeta().copyWith(
          perPage: state.meta.perPage,
          searchQuery: event.searchQuery, // cha
          orderBy: state.meta.orderBy,
          sort: state.meta.sort, // nge the search query),
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

  void _onScroll() {
    if (!scrollController.hasClients) {
      return;
    }

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    // if it over the threshold
    if (maxScroll - currentScroll <= 200) {
      // only fetch if it is not fetching and has not reached end
      if (!state.isFetching && !state.meta.hasReachedEnd) {
        add(ULFetchEvent());
      }
    }
  }

  @override
  Future<void> close() {
    // mark that this is not available anymore
    _isAvailable = false;
    // dispose the scroll controller
    scrollController.dispose();

    return super.close();
  }
}
