/// Async refresh controller
class AsyncRefreshController {
  final bool resetOnRefresh;

  AsyncRefreshController({
    this.resetOnRefresh = true,
  });

  Future<void> Function() refresh;
}
