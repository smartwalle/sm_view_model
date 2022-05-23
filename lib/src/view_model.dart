import 'package:flutter/material.dart';
import 'package:sm_view_state/src/view_state.dart';
import 'package:state_notifier/state_notifier.dart';

class ViewModel<T> extends StateNotifier<ViewState<T>> {
  ViewModel(T? data) : super(ViewState<T>(data: data));

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
  ViewState<T> get state {
    return super.state;
  }

  load([T? data]) {
    state = state.load(data);
  }

  finish([T? data, Object? error]) {
    state = state.finish(data, error);
  }

  updateState(ViewState<T> nState) {
    state = nState;
  }
}
