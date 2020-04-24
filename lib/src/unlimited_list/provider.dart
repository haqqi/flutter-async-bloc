import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'event.dart';
import 'request.dart';

class UnlimitedListBlocProvider<M, U extends UnlimitedListUseCase<M>>
    extends BlocProvider<UnlimitedListBloc<M, U>> {
  UnlimitedListBlocProvider({
    @required U Function(BuildContext context) useCase,
    Widget child,
    Key key,
  })  : assert(useCase != null),
        super(
          create: (BuildContext context) {
            return UnlimitedListBloc(
              useCase: useCase(context),
            )..add(UnlimitedListFetchEvent());
          },
          child: child,
          key: key,
        );
}
