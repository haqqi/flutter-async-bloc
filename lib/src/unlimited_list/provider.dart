import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'event.dart';
import 'request.dart';

class ULBlocProvider<M, U extends ULUseCase<M>>
    extends BlocProvider<ULBloc<M, U>> {
  ULBlocProvider({
    @required U Function(BuildContext context) useCase,
    Widget child,
    Key key,
  })  : assert(useCase != null),
        super(
          create: (BuildContext context) {
            return ULBloc(
              useCase: useCase(context),
            )..add(ULFetchEvent());
          },
          child: child,
          key: key,
        );
}
