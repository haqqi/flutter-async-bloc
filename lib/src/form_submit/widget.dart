import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/response.dart';
import 'bloc.dart';
import 'event.dart';
import 'request.dart';
import 'state.dart';

/// Type definition for async response callback success that has build context
///
typedef FSSuccessCallback<R> = void Function(
  BuildContext context,
  R data,
);

/// Type definition for async response callback error that has build context
///
typedef FSErrorCallback = void Function(
  BuildContext context,
  AsyncError error,
);

class FSWidget<R, U extends FSUseCase<R>> extends StatelessWidget {
  /// form builder of the use case
  final Widget Function(BuildContext context, U useCase) formBuilder;

  FSWidget({
    @required this.formBuilder,
    Key key,
  })  : assert(formBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final FSBloc<R, U> bloc = BlocProvider.of<FSBloc<R, U>>(context);

    return Form(
      key: bloc.useCase.formKey,
      child: formBuilder(context, bloc.useCase),
    );
  }
}

class FSButton<R, U extends FSUseCase<R>> extends StatelessWidget {
  /// if this is defined, we catch the sending blocking
  final WidgetBuilder blockLoader;

  /// Success callback
  final FSSuccessCallback<R> onSuccess;

  /// Success callback
  final FSErrorCallback onError;

  final Widget Function(BuildContext context, GestureTapCallback send) builder;

  FSButton({
    @required this.builder,
    @required this.onSuccess,
    this.onError,
    this.blockLoader,
    Key key,
  })  : assert(onSuccess != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final FSBloc<R, U> bloc = BlocProvider.of<FSBloc<R, U>>(context);

    return BlocListener<FSBloc<R, U>, FSState>(
      bloc: bloc,
      listener: (BuildContext context, FSState state) {
        // loader listener
        if (state is FSSendingState) {
          if (blockLoader != null) {
            // show dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: blockLoader,
            );
          }
        }
        if (state is FSDoneState<R>) {
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
      child: BlocBuilder<FSBloc<R, U>, FSState>(
        bloc: bloc,
        builder: (BuildContext context, FSState state) {
          GestureTapCallback onTap;

          if (!(state is FSSendingState)) {
            onTap = () async {
              bloc.add(FSSendEvent());
            };
          }

          return builder(context, onTap);
        },
      ),
    );
  }
}
