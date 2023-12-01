enum KIViewStateType {
  initial, // 初始
  loading, // 加载中
  finished, // 完成
}

class KIViewState<T> {
  KIViewState({
    this.type = KIViewStateType.initial,
    this.data,
    this.error,
  });

  // 状态类型
  KIViewStateType type = KIViewStateType.initial;

  bool get isInitial => type == KIViewStateType.initial;

  bool get isLoading => type == KIViewStateType.loading;

  bool get isFinished => type == KIViewStateType.finished;

  bool get isFailure => type == KIViewStateType.finished && error != null;

  // 数据
  T? data;

  // 错误
  Object? error;

  /// 复制一份 [KIViewState]。
  KIViewState<T> copy() {
    var nState = KIViewState<T>(data: data);
    nState.type = type;
    nState.data = data;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [KIViewState] 的实例，其状态为 [KIViewStateType.loading]。
  /// 如果参数 data 为 null 并且 force 为 false，则新 [KIViewState] 实例将继承原有数据。
  /// 错误信息不会被继承。
  KIViewState<T> load([T? data, bool force = false]) {
    var nState = KIViewState<T>(data: force ? data : data ?? this.data);
    nState.type = KIViewStateType.loading;
    nState.error = null;
    return nState;
  }

  /// 构建并返回一个 [KIViewState] 的实例，其状态为 [KIViewStateType.finished]。
  /// 新 [KIViewState] 实例的数据和错误信息会用参数 [data] 和 [error] 更新。
  KIViewState<T> finish(T? data, [Object? error]) {
    var nState = KIViewState<T>(data: data);
    nState.type = KIViewStateType.finished;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [KIViewState] 的实例，其状态为 [KIViewStateType.finished]。
  /// 新 [KIViewState] 实例将继承原有数据，其错误信息会用参数 [error] 更新。
  KIViewState<T> fail(Object error) {
    var nState = KIViewState<T>(data: data);
    nState.type = KIViewStateType.finished;
    nState.error = error;
    return nState;
  }
}
