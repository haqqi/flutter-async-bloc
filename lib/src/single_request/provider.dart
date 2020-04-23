import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'event.dart';
import 'request.dart';

class SRBlocProvider<R, U extends SRUseCase<R>>
    extends BlocProvider<SRBloc<R, U>> {
  SRBlocProvider({
    @required U Function(BuildContext context) useCase,
    Widget child,
    Key key,
  })  : assert(useCase != null),
        super(
          create: (BuildContext context) {
            return SRBloc<R, U>(
              useCase: useCase(context),
            )..add(SRFetchEvent());
          },
          child: child,
          key: key,
        );
}
