import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../core/bloc.dart';
import '../core/usecase.dart';

@immutable
class AsyncSimpleProvider<D, U extends AsyncUseCaseInterface<D>>
    extends SingleChildStatelessWidget {
  // the simple request creator
  final U Function(BuildContext context) create;

  AsyncSimpleProvider({
    @required this.create,
    Key key,
    Widget child,
  })  : assert(create != null),
        super(child: child, key: key);

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return BlocProvider<AsyncBloc<D, U>>(
      create: (BuildContext context) {
        // create usecase
        U useCase = create(context);

        // it's created!
        AsyncBloc<D, U> bloc = AsyncBloc<D, U>(
          useCase: useCase,
        );

        return bloc;
      },
      child: child,
    );
  }
}
