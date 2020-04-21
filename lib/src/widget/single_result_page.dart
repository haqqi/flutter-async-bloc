import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/async.dart';
import '../bloc/state.dart';
import '../common/refresh_controller.dart';
import '../common/response.dart';
import '../common/usecase.dart';
import '../common/widget.dart';

/// Single result page based on the data [D]
class AsyncSingleResultPage<D, U extends AsyncUseCaseInterface<D>>
    extends StatefulWidget {
  /// Loading widget builder. If it is null, default widget will be shown.
  final WidgetBuilder loadingBuilder;

  /// Error widget builder. If it is null, error message will be shown.
  final Widget Function(BuildContext context, AsyncError error) errorBuilder;

  /// Result widget builder. Must have scroll area to support refresh indicator.
  /// Either using single child scrollable or list view with AlwaysScrollablePhysics
  final Widget Function(BuildContext context, D result) resultBuilder;

  /// Refresh controller if needed
  final AsyncRefreshController refreshController;

  AsyncSingleResultPage({
    this.loadingBuilder,
    this.errorBuilder,
    @required this.resultBuilder,
    this.refreshController,
    Key key,
  })  : assert(resultBuilder != null),
        super(key: key);

  @override
  _AsyncSingleResultPageState<D, U> createState() =>
      _AsyncSingleResultPageState<D, U>();
}

class _AsyncSingleResultPageState<D, U extends AsyncUseCaseInterface<D>>
    extends State<AsyncSingleResultPage<D, U>> {
  // response state
  AsyncResponse<D> response;

  // just a bloc holder
  AsyncBloc<D, U> bloc;

  // effective controller for refresh
  AsyncRefreshController _effectiveController;

  @override
  void initState() {
    super.initState();

    // get the bloc
    bloc = BlocProvider.of<AsyncBloc<D, U>>(context);
    // initialize send
    bloc.send();

    // check default controller
    if (widget.refreshController == null) {
      _effectiveController = AsyncRefreshController();
    } else {
      _effectiveController = widget.refreshController;
    }
    // assign refresh function
    _effectiveController.refresh = refresh;
  }

  @override
  Widget build(BuildContext context) {
    Widget display;

    // if response is null, show on loading
    if (response == null) {
      display = OnLoadingWidget();
    } else {
      Widget displayChild;

      // if has error, show error widget
      if (response.hasError) {
        displayChild = _OnErrorWidget(
          error: response.error,
        );
      } else {
        displayChild = widget.resultBuilder(
          context,
          response.data,
        );
      }

      display = RefreshIndicator(
        onRefresh: refresh,
        child: displayChild,
      );
    }

    return BlocListener(
      bloc: bloc,
      listener: (BuildContext context, AsyncState state) {
        // listener only to set the response
        if (state is AsyncDoneState<D>) {
          setState(() {
            response = state.response;
          });
        }
      },
      condition: (AsyncState prevState, AsyncState nextState) {
        return nextState is AsyncDoneState<D>;
      },
      child: display,
    );
  }

  Future<void> refresh() async {
    if (_effectiveController.resetOnRefresh) {
      setState(() {
        response = null;
      });
    }
    return await bloc.send();
  }
}

/// Simplify error widget algorithm
class _OnErrorWidget extends StatelessWidget {
  final Widget Function(BuildContext context, AsyncError error) errorBuilder;
  final AsyncError error;

  _OnErrorWidget({
    @required this.error,
    this.errorBuilder,
    Key key,
  })  : assert(error != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget effectiveWidget;

    if (errorBuilder != null) {
      // build the error
      effectiveWidget = errorBuilder(context, error);
    } else {
      // default error
      effectiveWidget = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Center(
          child: Text(
            error.code.toString() + ": " + error.message,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: effectiveWidget,
    );
  }
}
