import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/callback.dart';
import '../common/response.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';
import 'usecase.dart';

class AsyncFormBuilder<F, R, B extends AsyncFormBloc<F, R>>
    extends StatelessWidget {
  /// form builder of the use case
  final Widget Function(BuildContext context, F form) builder;

  AsyncFormBuilder({
    @required this.builder,
    Key key,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final B bloc = BlocProvider.of<B>(context);

    return BlocBuilder<B, AsyncFormState<F>>(
      bloc: bloc,
      builder: (BuildContext context, AsyncFormState<F> state) {
        return builder(context, state.form);
      },
    );
  }
}

typedef AsyncFormSubmit = Function();

class AsyncFormButton<F, R, B extends AsyncFormBloc<F, R>>
    extends StatelessWidget {
  /// if this is defined, we catch the sending blocking
  final WidgetBuilder blockLoader;

  /// Success callback
  final OnSuccessCallback<R> onSuccess;

  /// Success callback
  final OnErrorCallback onError;

  /// Check if the button can do submission or not
  final bool Function(F form) canSubmit;

  /// Real button builder
  final Widget Function(BuildContext context, AsyncFormSubmit submit) builder;

  /// Use case for sending
  final AsyncFormUseCase<F, R> Function(BuildContext context) useCase;

  AsyncFormButton({
    @required this.builder,
    @required this.onSuccess,
    @required this.useCase,
    this.onError,
    this.blockLoader,
    this.canSubmit,
    Key key,
  })  : assert(builder != null),
        assert(onSuccess != null),
        assert(useCase != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final B bloc = BlocProvider.of<B>(context);

    // sending and done event
    return BlocListener<B, AsyncFormState<F>>(
      bloc: bloc,
      condition: (AsyncFormState<F> previous, AsyncFormState<F> current) {
        if (current is AsyncFormSending<F> || current is AsyncFormDone<F, R>) {
          return true;
        }

        return false;
      },
      listener: (BuildContext context, AsyncFormState<F> state) {
        // if it is sending
        if (state is AsyncFormSending<F>) {
          if (blockLoader != null) {
            // show dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: blockLoader,
            );
          }
        } else if (state is AsyncFormDone<F, R>) {
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
      child: BlocBuilder<B, AsyncFormState<F>>(
        bloc: bloc,
        builder: (BuildContext context, AsyncFormState<F> state) {
          // if it is not a ready state, we just return null
          if (!(state is AsyncFormReady<F>)) {
            return builder(context, null);
          }

          // if can submit is not defined, we can submit
          if (canSubmit == null || canSubmit(state.form)) {
            return builder(
              context,
              () async {
                // do the submission, change the state
                bloc.add(AsyncFormSend());

                AsyncResponse<R> response =
                    await useCase(context).validateAndSend(state.form);

                bloc.add(AsyncFormReceiveResponse<R>(response: response));
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
