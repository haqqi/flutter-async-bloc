import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  /// Padding for the list view
  final EdgeInsetsGeometry padding;

  UnlimitedListWidget({
    @required this.listTileBuilder,
    this.padding,
    Key key,
  })  : assert(listTileBuilder != null),
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
            return OnLoadingWidget();
          }

          if (state.hasError) {
            // if it has error
            effectiveWidget = OnErrorWidget(
              error: state.error,
            );
          } else {
            // if the state is already success, but with zero data, show empty message
            effectiveWidget = EmptyListMessageWidget();
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
                return LinearProgressIndicator();
              }

              // get the data
              M single = state.data[index];

              // build it!
              return listTileBuilder(context, single);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox();
            },
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
