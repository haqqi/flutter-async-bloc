import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'request.dart';

class FormSubmitBlocProvider<R, U extends FormSubmitUseCase<R>>
    extends BlocProvider<FormSubmitBloc<R, U>> {
  FormSubmitBlocProvider({
    /// Use case builder
    @required U Function(BuildContext context) useCase,
    Widget child,
    Key key,
  })  : assert(useCase != null),
        super(
          create: (BuildContext context) {
            return FormSubmitBloc<R, U>(
              useCase: useCase(context),
            );
          },
          child: child,
          key: key,
        );
}
