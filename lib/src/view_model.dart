import 'package:flutter/material.dart';
import 'package:sm_view_state/src/view_state.dart';
import 'package:state_notifier/state_notifier.dart';

class KIViewModel<T> extends StateNotifier<KIViewState<T>> {
  KIViewModel(T? data) : super(KIViewState<T>(data: data));

  @protected
  T? get data {
    return state.data;
  }

  @protected
  Object? get error {
    return state.error;
  }

  @protected
  bool get hasError {
    return state.hasError;
  }

  @protected
  bool get isInit {
    return state.isInitial;
  }

  @protected
  bool get isLoading {
    return state.isLoading;
  }

  @protected
  bool get isFinished {
    return state.isFinished;
  }

  @override
  KIViewState<T> get state {
    return super.state;
  }

  load([T? data]) {
    state = state.load(data);
  }

  finish([T? data, Object? error]) {
    state = state.finish(data, error);
  }

  reset(KILoadState nState, [T? data, Object? error]) {
    state = KIViewState<T>(data: data, state: nState, error: error);
  }
}
