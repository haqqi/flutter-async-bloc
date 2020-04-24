import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'event.dart';
import 'request.dart';

class SingleRequestBlocProvider<R, U extends SingleRequestUseCase<R>>
    extends BlocProvider<SingleRequestBloc<R, U>> {
  SingleRequestBlocProvider({
    @required U Function(BuildContext context) useCase,
    Widget child,
    Key key,
  })  : assert(useCase != null),
        super(
          create: (BuildContext context) {
            return SingleRequestBloc<R, U>(
              useCase: useCase(context),
            )..add(SingleRequestFetchEvent());
          },
          child: child,
          key: key,
        );
}
