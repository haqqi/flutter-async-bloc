import 'package:flutter/material.dart';

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
      effectiveWidget = Padding(
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

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: effectiveWidget,
    );
  }
}
