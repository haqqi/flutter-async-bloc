import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/async.dart';
import '../common/usecase.dart';

@immutable
class AsyncBlocProvider<D, U extends AsyncUseCaseInterface<D>>
    extends BlocProvider<AsyncBloc<D, U>> {
  AsyncBlocProvider({
    /// Create use case
    U Function(BuildContext context) createUseCase,

    /// The child
    Widget child,

    /// Just a key
    Key key,
  })  : assert(createUseCase != null),
        super(
          create: (BuildContext context) {
            U useCase = createUseCase(context);
            // it's created!
            AsyncBloc<D, U> bloc = AsyncBloc<D, U>(
              useCase: useCase,
            );

            return bloc;
          },
          child: child,
          key: key,
        );
}
