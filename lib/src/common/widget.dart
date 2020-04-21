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
class EmptyListWidget extends StatelessWidget {
  final WidgetBuilder emptyListMessageBuilder;

  EmptyListWidget({
    this.emptyListMessageBuilder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget effectiveWidget;

    if (emptyListMessageBuilder != null) {
      // build the loading
      effectiveWidget = emptyListMessageBuilder(context);
    } else {
      // default loading
      effectiveWidget = Center(
        child: CircularProgressIndicator(),
      );
    }

    return effectiveWidget;
  }
}
