import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/callback.dart';
import 'bloc.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

class FormSubmitWidget<R, U extends FormSubmitUseCase<R>>
    extends StatelessWidget {
  /// form builder of the use case
  final Widget Function(BuildContext context, U useCase) formBuilder;

  FormSubmitWidget({
    @required this.formBuilder,
    Key key,
  })  : assert(formBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final FormSubmitBloc<R, U> bloc =
        BlocProvider.of<FormSubmitBloc<R, U>>(context);

    return Form(
      key: bloc.useCase.formKey,
      child: formBuilder(context, bloc.useCase),
    );
  }
}

class FormSubmitButton<R, U extends FormSubmitUseCase<R>>
    extends StatelessWidget {
  /// if this is defined, we catch the sending blocking
  final WidgetBuilder blockLoader;

  /// Success callback
  final OnSuccessCallback<R> onSuccess;

  /// Success callback
  final OnErrorCallback onError;

  final Widget Function(BuildContext context, GestureTapCallback send) builder;

  FormSubmitButton({
    @required this.builder,
    @required this.onSuccess,
    this.onError,
    this.blockLoader,
    Key key,
  })  : assert(builder != null),
        assert(onSuccess != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final FormSubmitBloc<R, U> bloc =
        BlocProvider.of<FormSubmitBloc<R, U>>(context);

    return BlocListener<FormSubmitBloc<R, U>, FormSubmitState>(
      bloc: bloc,
      listener: (BuildContext context, FormSubmitState state) {
        // loader listener
        if (state is FormSubmitSendingState) {
          if (blockLoader != null) {
            // show dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: blockLoader,
            );
          }
        }
        if (state is FormSubmitDoneState<R>) {
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
      child: BlocBuilder<FormSubmitBloc<R, U>, FormSubmitState>(
        bloc: bloc,
        builder: (BuildContext context, FormSubmitState state) {
          GestureTapCallback onTap;

          if (!(state is FormSubmitSendingState)) {
            onTap = () async {
              bloc.add(FormSubmitSendEvent());
            };
          }

          return builder(context, onTap);
        },
      ),
    );
  }
}
