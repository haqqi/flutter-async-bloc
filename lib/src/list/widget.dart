import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/response.dart';
import 'bloc.dart';
import 'event.dart';
import 'request.dart';
import 'response.dart';
import 'state.dart';
import 'usecase.dart';

/// builder for the widget
//typedef ListTileBuilder<M> = Widget Function(BuildContext context, M model);

class AsyncListWidget<LD extends AsyncListData<dynamic>,
    R extends AsyncListResponse<dynamic>> extends StatefulWidget {
  final AsyncListUseCase<LD, R> Function(BuildContext context) useCase;

  AsyncListWidget({
    @required this.useCase,
    Key key,
  }) : super(key: key);

  @override
  _AsyncListWidgetState<LD, R> createState() => _AsyncListWidgetState<LD, R>();
}

class _AsyncListWidgetState<LD extends AsyncListData<dynamic>,
        R extends AsyncListResponse<dynamic>>
    extends State<AsyncListWidget<LD, R>> {
  AsyncListBloc<LD, R> bloc;
  AsyncListUseCase<LD, R> useCase;

  @override
  void initState() {
    super.initState();
    // init bloc
    bloc = BlocProvider.of<AsyncListBloc<LD, R>>(context);
    // create use case
    useCase = widget.useCase(context);
    // init the sending
    _fetchNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AsyncListBloc<LD, R>, AsyncListState<LD>>(
      bloc: bloc,
      builder: (BuildContext context, AsyncListState<LD> state) {
        return Container(
          child: Text('Asli'),
        );
      },
    );
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
}

class AsyncListWidget2<M> extends StatelessWidget {
  /// List tile builder that has parameter of [M]
//  final ListTileBuilder<M> listTileBuilder;

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

  /// Padding for the list view
  final EdgeInsetsGeometry padding;

  AsyncListWidget2({
//    @required this.listTileBuilder,
    @required this.separatorBuilder,
    this.loadingBuilder,
    this.errorResultBuilder,
    this.emptyMessageBuilder,
    this.nextPageFetchingIndicator,
    this.padding,
    Key key,
  })  : assert(separatorBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
//    final AsyncListBloc<M, U> bloc =
//    BlocProvider.of<AsyncListBloc<M, U>>(context);

    return Container();
  }
}
