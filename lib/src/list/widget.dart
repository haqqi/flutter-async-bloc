import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/response.dart';
import '../common/widget.dart';
import 'bloc.dart';
import 'event.dart';
import 'request.dart';
import 'response.dart';
import 'state.dart';
import 'usecase.dart';

/// builder for the widget
typedef AsyncListBuilder<M> = Widget Function(BuildContext context, M model);

class AsyncListWidget<M, LD extends AsyncListData<M>,
    R extends AsyncListResponse<M>> extends StatefulWidget {
  /// Default use case for this list widget
  final AsyncListUseCase<M, LD, R> Function(BuildContext context) useCase;

  /// List tile builder that has parameter of [M]
  final AsyncListBuilder<M> listTileBuilder;

  /// Indexed separator widget
  final IndexedWidgetBuilder separatorBuilder;

  /// First loading widget builder. If it is null, default widget will be shown.
  final WidgetBuilder loadingBuilder;

  /// First loading error widget builder. If it is null, error message will be shown.
  final Widget Function(BuildContext context, AsyncError error)
      errorResultBuilder;

  /// Empty message builder for first load
  final WidgetBuilder emptyMessageBuilder;

  /// Next page loading indicator
  final Widget nextPageFetchingIndicator;

  AsyncListWidget({
    @required this.useCase,
    @required this.listTileBuilder,
    this.separatorBuilder,
    this.loadingBuilder,
    this.errorResultBuilder,
    this.emptyMessageBuilder,
    this.nextPageFetchingIndicator,
    Key key,
  })  : assert(listTileBuilder != null),
        super(key: key);

  @override
  AsyncListWidgetState<M, LD, R> createState() =>
      AsyncListWidgetState<M, LD, R>();
}

class AsyncListWidgetState<M, LD extends AsyncListData<M>,
    R extends AsyncListResponse<M>> extends State<AsyncListWidget<M, LD, R>> {
  // holder for bloc
  AsyncListBloc<M, LD, R> bloc;

  // holder for useCase
  AsyncListUseCase<M, LD, R> useCase;

  // holder for error
  AsyncError error;

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    // init bloc
    bloc = BlocProvider.of<AsyncListBloc<M, LD, R>>(context);
    // create use case
    useCase = widget.useCase(context);
    // init scroll controller
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    // init the sending
    _fetchNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AsyncListBloc<M, LD, R>, AsyncListState<M, LD>>(
      bloc: bloc,
      listener: (BuildContext context, AsyncListState<M, LD> state) {
        // reset error first
        error = null;
        // set error if any
        if (state is AsyncListProcessingResponseState<M, LD, R> &&
            state.response.hasError) {
          error = state.response.error;
        }
      },
      child: BlocBuilder<AsyncListBloc<M, LD, R>, AsyncListState<M, LD>>(
        bloc: bloc,
        builder: (BuildContext context, AsyncListState<M, LD> state) {
          Widget effectiveWidget;

          // if the data is still empty
          if (state.list.length == 0) {
            // if it is first fetching, show the on loading widget
            if (state is AsyncListFetchingState<M, LD>) {
              // just return the on loading widget
              return OnLoadingWidget(
                loadingBuilder: widget.loadingBuilder,
              );
            }

            if (error != null) {
              // if it has error
              effectiveWidget = OnErrorWidget(
                errorBuilder: widget.errorResultBuilder,
                error: error,
              );
            } else {
              // if the state is already success, but with zero data, show empty message
              effectiveWidget = EmptyListMessageWidget(
                emptyListMessageBuilder: widget.emptyMessageBuilder,
              );
            }
          } else {
            bool isFetching = (state is AsyncListFetchingState<M, LD>);

            // if the result is above 0, just display the result
            effectiveWidget = ListView.separated(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
//              padding: padding,
              itemBuilder: (BuildContext context, int index) {
                // build loading process
                if (index == state.list.length) {
                  return widget.nextPageFetchingIndicator ??
                      LinearProgressIndicator();
                }

                // get the data
                dynamic single = state.list[index];

                // build it!
                return widget.listTileBuilder(context, single);
              },
              separatorBuilder: widget.separatorBuilder ??
                  (BuildContext context, int index) {
                    return SizedBox();
                  },
              itemCount: state.list.length + (isFetching ? 1 : 0),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: effectiveWidget,
          );
        },
      ),
    );
  }

  Future<void> _refresh() async {
    // send async list fetch event
    bloc.add(AsyncListFetchEvent());

    // do the fetch
    AsyncResponse<R> response = await useCase.fetch(
      AsyncListRequestMeta.refresh(bloc.state.meta),
      bloc.state.list,
    );

    // send async receive response
    bloc.add(AsyncListReceiveResponse<R>(response: response));
  }

  Future<void> _fetchNextPage() async {
    // send async list fetch event
    bloc.add(AsyncListFetchEvent());

    // do the fetch
    AsyncResponse<R> response = await useCase.fetch(
      AsyncListRequestMeta.nextPage(bloc.state.meta),
      bloc.state.list,
    );

    // send async receive response
    bloc.add(AsyncListReceiveResponse<R>(response: response));
  }

  void _onScroll() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    // if it over the threshold
    if (maxScroll - currentScroll <= 200) {
      // only fetch if it is ready and has not reached end
      if (bloc.state is AsyncListReadyState<M, LD> &&
          !bloc.state.meta.hasReachedEnd) {
        _fetchNextPage();
      }
    }
  }
}
