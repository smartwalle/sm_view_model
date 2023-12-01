import 'package:sm_view_state/src/view_state.dart';
import 'package:state_notifier/state_notifier.dart';

class KIViewModel<T> extends StateNotifier<KIViewState<T>> {
  KIViewModel(T? data) : super(KIViewState<T>(data: data));

  T? get data {
    return state.data;
  }

  Object? get error {
    return state.error;
  }

  bool get isInitial {
    return state.isInitial;
  }

  bool get isLoading {
    return state.isLoading;
  }

  bool get isFinished {
    return state.isFinished;
  }

  bool get isFailure {
    return state.isFailure;
  }

  @override
  KIViewState<T> get state {
    return super.state;
  }

  load([T? data, bool force = false]) {
    state = state.load(data, force);
  }

  finish([T? data, Object? error]) {
    state = state.finish(data, error);
  }

  fail(Object error) {
    state = state.fail(error);
  }

  refresh(KIViewStateType type, [T? data, Object? error]) {
    state = KIViewState<T>(data: data, type: type, error: error);
  }
}
