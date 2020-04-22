import 'package:flutter/material.dart';

import 'response.dart';

/// Simplify loading widget algorithm.
class OnLoadingWidget extends StatelessWidget {
  final WidgetBuilder loadingBuilder;

  OnLoadingWidget({
    this.loadingBuilder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget effectiveWidget;

    if (loadingBuilder != null) {
      // build the loading
      effectiveWidget = loadingBuilder(context);
    } else {
      // default loading
      effectiveWidget = Center(
        child: CircularProgressIndicator(),
      );
    }

    return effectiveWidget;
  }
}

/// Simplify error widget algorithm
class OnErrorWidget extends StatelessWidget {
  final Widget Function(BuildContext context, AsyncError error) errorBuilder;
  final AsyncError error;

  OnErrorWidget({
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
      effectiveWidget = Container(
        height: double.maxFinite,
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

    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: effectiveWidget,
        ),
      ],
    );
  }
}

/// Simplify loading widget algorithm.
class EmptyListMessageWidget extends StatelessWidget {
  final WidgetBuilder emptyListMessageBuilder;

  EmptyListMessageWidget({
    this.emptyListMessageBuilder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget effectiveWidget;

    if (emptyListMessageBuilder != null) {
      // build the error
      effectiveWidget = emptyListMessageBuilder(context);
    } else {
      // default error
      effectiveWidget = Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Center(
          child: Text(
            "Sorry, this page does not have data yet.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: effectiveWidget,
        ),
      ],
    );
  }
}
