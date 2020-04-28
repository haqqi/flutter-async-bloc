import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/callback.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class FormSubmitWidget<F, R, B extends FormSubmitBloc<F, R>>
    extends StatelessWidget {
  /// form builder of the use case
  final Widget Function(BuildContext context, F form) formBuilder;

  FormSubmitWidget({
    @required this.formBuilder,
    Key key,
  })  : assert(formBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final B bloc = BlocProvider.of<B>(context);

    return Form(
      key: bloc.useCase.formKey,
      child: BlocBuilder<B, FormSubmitState<F, R>>(
        bloc: bloc,
        builder: (BuildContext context, FormSubmitState<F, R> state) {
          return formBuilder(context, state.formData);
        },
      ),
    );
  }
}

class FormSubmitButton<F, R, B extends FormSubmitBloc<F, R>>
    extends StatelessWidget {
  /// if this is defined, we catch the sending blocking
  final WidgetBuilder blockLoader;

  /// Success callback
  final OnSuccessCallback<R> onSuccess;

  /// Success callback
  final OnErrorCallback onError;

  final Widget Function(BuildContext context, GestureTapCallback send) builder;

  final bool Function(F form) canSubmit;

  FormSubmitButton({
    @required this.builder,
    @required this.onSuccess,
    this.canSubmit,
    this.onError,
    this.blockLoader,
    Key key,
  })  : assert(builder != null),
        assert(onSuccess != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final B bloc = BlocProvider.of<B>(context);

    return BlocListener<B, FormSubmitState<F, R>>(
      bloc: bloc,
      listener: (BuildContext context, FormSubmitState<F, R> state) {
        // loader listener
        if (state.isSending) {
          if (blockLoader != null) {
            // show dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: blockLoader,
            );
          }
        }

        if (!state.isSending) {
          if (blockLoader != null) {
            // pop the dialog
            Navigator.of(context).pop();
          }

          // if has error
          if (state.response.hasError) {
            // if has on error callback
            if (onError != null) {
              onError(context, state.response.error);
            }
          } else {
            // if success
            onSuccess(context, state.response.data);
          }
        }
      },
      condition: (FormSubmitState<F, R> prevState,
          FormSubmitState<F, R> currentState) {
        return (prevState.isSending != currentState.isSending);
      },
      child: BlocBuilder<B, FormSubmitState<F, R>>(
        bloc: bloc,
        builder: (BuildContext context, FormSubmitState<F, R> state) {
          // can only submit if not sending
          if (state.isSending) {
            return builder(context, null);
          }

          // if can submit is not defined, we can submit
          if (canSubmit == null || canSubmit(state.formData)) {
            return builder(
              context,
              () async {
                bloc.add(FormSubmitSendEvent());
              },
            );
          }

          // otherwise, cannot submit
          return builder(context, null);
        },
      ),
    );
  }
}
