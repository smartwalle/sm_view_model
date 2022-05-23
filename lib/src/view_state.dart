enum LoadState {
  initial, // 初始
  loading, // 加载中
  finished, // 完成
}

class ViewState<T> {
  ViewState({
    this.data,
    this.state = LoadState.initial,
    this.error,
  });

  // 状态
  LoadState state = LoadState.initial;

  bool get isInitial => state == LoadState.initial;

  bool get isLoading => state == LoadState.loading;

  bool get isFinished => state == LoadState.finished;

  // 数据
  T? data;

  // 错误
  Object? error;

  bool get hasError => error != null;

  /// 复制一份 [ViewState]。
  ViewState<T> copy() {
    var nState = ViewState<T>(data: data);
    nState.state = state;
    nState.data = data;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [ViewState] 的实例，其状态为 [LoadState.loading]。
  /// 如果参数 data 为 null，则新 [ViewState] 实例将继承原有数据。
  /// 错误信息不会被继承。
  ViewState<T> load([T? data]) {
    var nState = ViewState<T>(data: data ?? this.data);
    nState.state = LoadState.loading;
    nState.error = null;
    return nState;
  }

  /// 构建并返回一个 [ViewState] 的实例，其状态为 [LoadState.finished]。
  /// 新 [ViewState] 实例的数据和错误信息会用参数 [data] 和 [error] 更新。
  ViewState<T> finish(T? data, [Object? error]) {
    var nState = ViewState<T>(data: data);
    nState.state = LoadState.finished;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [ViewState] 的实例，其状态为 [LoadState.finished]。
  /// 新 [ViewState] 实例将继承原有数据，其错误信息会用参数 [error] 更新。
  ViewState<T> finishWithError(Object error) {
    var nState = ViewState<T>(data: data);
    nState.state = LoadState.finished;
    nState.error = error;
    return nState;
  }
}
