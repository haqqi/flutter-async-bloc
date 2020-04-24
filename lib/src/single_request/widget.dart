import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../common/callback.dart';
import '../common/response.dart';
import '../common/widget.dart';
import 'bloc.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

/// Single request widget, to display the result after done event.
class SingleRequestResultWidget<R, U extends SingleRequestUseCase<R>>
    extends StatelessWidget {
  /// Builder of the result
  final Widget Function(BuildContext context, R result) resultBuilder;

  /// First loading widget builder. If it is null, default widget will be shown.
  final WidgetBuilder loadingBuilder;

  /// First loading error widget builder. If it is null, error message will be shown.
  final Widget Function(BuildContext context, AsyncError error)
      errorResultBuilder;

  SingleRequestResultWidget({
    @required this.resultBuilder,
    this.loadingBuilder,
    this.errorResultBuilder,
    Key key,
  })  : assert(resultBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final SingleRequestBloc<R, U> bloc = BlocProvider.of<SingleRequestBloc<R, U>>(context);

    return BlocBuilder<SingleRequestBloc<R, U>, SingleRequestState>(
      bloc: bloc,
      builder: (BuildContext context, SingleRequestState state) {
        if (state is SingleRequestFetchingState<R>) {
          // if has previous result, return the result
          if (state.hasPreviousResult) {
            return resultBuilder(context, state.previousResult);
          } else {
            // return loading
            return OnLoadingWidget(
              loadingBuilder: loadingBuilder,
            );
          }
        }

        // assume the other is done state
        else if (state is SingleRequestDoneState<R>) {
          Widget effectiveWidget;

          if (state.response.hasError) {
            effectiveWidget = OnErrorWidget(
              error: state.response.error,
              errorBuilder: errorResultBuilder,
            );
          } else {
            effectiveWidget = resultBuilder(context, state.response.data);
          }

          return RefreshIndicator(
            onRefresh: () async {
              bloc.add(SingleRequestFetchEvent());
            },
            child: effectiveWidget,
          );
        } else {
          return Container(
            child: Center(
              child: Text("Seems like you haven't send the request"),
            ),
          );
        }
      },
    );
  }
}

class SingleRequestOnDoneListener<R, U extends SingleRequestUseCase<R>>
    extends SingleChildStatelessWidget {
  /// Success callback
  final OnSuccessCallback<R> onSuccess;
  final OnErrorCallback onError;

  SingleRequestOnDoneListener({
    this.onSuccess,
    this.onError,
    Widget child,
    Key key,
  })  : assert(onSuccess != null),
        super(
          child: child,
          key: key,
        );

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    final SingleRequestBloc<R, U> bloc = BlocProvider.of<SingleRequestBloc<R, U>>(context);

    return BlocListener<SingleRequestBloc<R, U>, SingleRequestState>(
      bloc: bloc,
      listener: (BuildContext context, SingleRequestState state) {
        if (state is SingleRequestDoneState<R>) {
          if (state.response.hasData && onSuccess != null) {
            onSuccess(context, state.response.data);
          } else if (state.response.hasError && onError != null) {
            onError(context, state.response.error);
          }
        }
      },
      condition: (SingleRequestState prevState, SingleRequestState currentState) {
        return (currentState is SingleRequestDoneState<R>);
      },
      child: child,
    );
  }
}
