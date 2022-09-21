enum KILoadState {
  initial, // 初始
  loading, // 加载中
  finished, // 完成
}

class KIViewState<T> {
  KIViewState({
    this.data,
    this.state = KILoadState.initial,
    this.error,
  });

  // 状态
  KILoadState state = KILoadState.initial;

  bool get isInitial => state == KILoadState.initial;

  bool get isLoading => state == KILoadState.loading;

  bool get isFinished => state == KILoadState.finished;

  // 数据
  T? data;

  // 错误
  Object? error;

  bool get hasError => error != null;

  /// 复制一份 [KIViewState]。
  KIViewState<T> copy() {
    var nState = KIViewState<T>(data: data);
    nState.state = state;
    nState.data = data;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [KIViewState] 的实例，其状态为 [KILoadState.loading]。
  /// 如果参数 data 为 null，则新 [KIViewState] 实例将继承原有数据。
  /// 错误信息不会被继承。
  KIViewState<T> load([T? data]) {
    var nState = KIViewState<T>(data: data ?? this.data);
    nState.state = KILoadState.loading;
    nState.error = null;
    return nState;
  }

  /// 构建并返回一个 [KIViewState] 的实例，其状态为 [KILoadState.finished]。
  /// 新 [KIViewState] 实例的数据和错误信息会用参数 [data] 和 [error] 更新。
  KIViewState<T> finish(T? data, [Object? error]) {
    var nState = KIViewState<T>(data: data);
    nState.state = KILoadState.finished;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [KIViewState] 的实例，其状态为 [KILoadState.finished]。
  /// 新 [KIViewState] 实例将继承原有数据，其错误信息会用参数 [error] 更新。
  KIViewState<T> finishWithError(Object error) {
    var nState = KIViewState<T>(data: data);
    nState.state = KILoadState.finished;
    nState.error = error;
    return nState;
  }
}
