import 'package:flutter/widgets.dart';

mixin FormWithKeyMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @mustCallSuper
  bool validate() {
    // if form key is attached, and validation failed, just return false
    if (formKey.currentState != null && !formKey.currentState.validate()) {
      return false;
    }

    // save the state
    formKey.currentState?.save();

    // validate the form
    return true;
  }
}
