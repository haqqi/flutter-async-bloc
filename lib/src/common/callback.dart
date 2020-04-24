import 'package:flutter/widgets.dart';

import 'response.dart';

/// Type definition for async response callback success that has build context
///
typedef OnSuccessCallback<R> = void Function(
  BuildContext context,
  R data,
);

/// Type definition for async response callback error that has build context
///
typedef OnErrorCallback = void Function(
  BuildContext context,
  AsyncError error,
);
