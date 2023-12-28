enum KIViewModelStateType {
  initial, // 初始
  loading, // 加载中
  finished, // 完成
}

class KIViewModelState<T> {
  KIViewModelState({
    this.type = KIViewModelStateType.initial,
    this.data,
    this.error,
  });

  // 状态类型
  KIViewModelStateType type = KIViewModelStateType.initial;

  bool get isInitial => type == KIViewModelStateType.initial;

  bool get isLoading => type == KIViewModelStateType.loading;

  bool get isFinished => type == KIViewModelStateType.finished;

  bool get isFailure => type == KIViewModelStateType.finished && error != null;

  // 数据
  T? data;

  // 错误
  Object? error;

  /// 复制一份 [KIViewModelState]。
  KIViewModelState<T> copy() {
    var nState = KIViewModelState<T>(data: data);
    nState.type = type;
    nState.data = data;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [KIViewModelState] 的实例，其状态为 [KIViewModelStateType.loading]。
  /// 如果参数 data 为 null 并且 force 为 false，则新 [KIViewModelState] 实例将继承原有数据。
  /// 错误信息不会被继承。
  KIViewModelState<T> load([T? data, bool force = false]) {
    var nState = KIViewModelState<T>(data: force ? data : data ?? this.data);
    nState.type = KIViewModelStateType.loading;
    nState.error = null;
    return nState;
  }

  /// 构建并返回一个 [KIViewModelState] 的实例，其状态为 [KIViewModelStateType.finished]。
  /// 新 [KIViewModelState] 实例的数据和错误信息会用参数 [data] 和 [error] 更新。
  KIViewModelState<T> finish(T? data, [Object? error]) {
    var nState = KIViewModelState<T>(data: data);
    nState.type = KIViewModelStateType.finished;
    nState.error = error;
    return nState;
  }

  /// 构建并返回一个 [KIViewModelState] 的实例，其状态为 [KIViewModelStateType.finished]。
  /// 新 [KIViewModelState] 实例将继承原有数据，其错误信息会用参数 [error] 更新。
  KIViewModelState<T> fail(Object error) {
    var nState = KIViewModelState<T>(data: data);
    nState.type = KIViewModelStateType.finished;
    nState.error = error;
    return nState;
  }
}
