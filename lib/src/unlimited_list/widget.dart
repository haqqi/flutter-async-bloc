import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/response.dart';
import '../common/widget.dart';
import 'bloc.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

/// builder for the widget
typedef ListTileBuilder<M> = Widget Function(BuildContext context, M model);

class UnlimitedListWidget<M, U extends ULUseCase<M>> extends StatelessWidget {
  /// List tile builder that has parameter of [M]
  final ListTileBuilder<M> listTileBuilder;

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

  UnlimitedListWidget({
    @required this.listTileBuilder,
    @required this.separatorBuilder,
    this.loadingBuilder,
    this.errorResultBuilder,
    this.emptyMessageBuilder,
    this.nextPageFetchingIndicator,
    this.padding,
    Key key,
  })  : assert(listTileBuilder != null),
        assert(separatorBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ULBloc<M, U> bloc = BlocProvider.of<ULBloc<M, U>>(context);

    return BlocBuilder<ULBloc<M, U>, ULState<M>>(
      bloc: bloc,
      builder: (BuildContext context, ULState<M> state) {
        Widget effectiveWidget;

        // if the data is still empty
        if (!state.hasData) {
          // if it is first fetching, show the on loading widget
          if (state.isFetching) {
            // just return the on loading widget
            return OnLoadingWidget(
              loadingBuilder: loadingBuilder,
            );
          }

          if (state.hasError) {
            // if it has error
            effectiveWidget = OnErrorWidget(
              errorBuilder: errorResultBuilder,
              error: state.error,
            );
          } else {
            // if the state is already success, but with zero data, show empty message
            effectiveWidget = EmptyListMessageWidget(
              emptyListMessageBuilder: emptyMessageBuilder,
            );
          }
        } else {
          // if the result is above 0, just display the result
          effectiveWidget = ListView.separated(
            controller: bloc.scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            padding: padding,
            itemBuilder: (BuildContext context, int index) {
              // build loading process
              if (index == state.data.length) {
                return nextPageFetchingIndicator ?? LinearProgressIndicator();
              }

              // get the data
              M single = state.data[index];

              // build it!
              return listTileBuilder(context, single);
            },
            separatorBuilder: separatorBuilder,
            itemCount: state.data.length + (state.isFetching ? 1 : 0),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // refresh event
            bloc.add(ULRefreshEvent());
          },
          child: effectiveWidget,
        );
      },
    );
  }
}
