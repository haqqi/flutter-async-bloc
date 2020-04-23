import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/response.dart';
import '../common/widget.dart';
import 'bloc.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

/// Single request widget, to display the result after done event.
class SRWidget<R, U extends SRUseCase<R>> extends StatelessWidget {
  /// Builder of the result
  final Widget Function(BuildContext context, R result) resultBuilder;

  /// First loading widget builder. If it is null, default widget will be shown.
  final WidgetBuilder loadingBuilder;

  /// First loading error widget builder. If it is null, error message will be shown.
  final Widget Function(BuildContext context, AsyncError error)
      errorResultBuilder;

  SRWidget({
    @required this.resultBuilder,
    this.loadingBuilder,
    this.errorResultBuilder,
    Key key,
  })  : assert(resultBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final SRBloc<R, U> bloc = BlocProvider.of<SRBloc<R, U>>(context);

    return BlocBuilder<SRBloc<R, U>, SRState>(
      bloc: bloc,
      builder: (BuildContext context, SRState state) {
        if (state is SRFetchingState<R>) {
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
        else if (state is SRDoneState<R>) {
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
              bloc.add(SRFetchEvent());
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
