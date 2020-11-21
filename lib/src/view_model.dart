import 'package:flutter/material.dart';

enum ViewModelState {
  _none,
  waiting,
  done,
}

class ViewModel extends ChangeNotifier {
  /// 状态信息
  ViewModelState _state = ViewModelState._none;

  ViewModelState get state => _state;

  bool get isWaiting => _state == ViewModelState.waiting;

  bool get isDone => _state == ViewModelState.done;

  set state(ViewModelState v) {
    if (_state != v) {
      _state = v;
      notifyListeners();
    }
  }

  void waiting() {
    this.state = ViewModelState.waiting;
  }

  void done([Object error]) {
    var notify = false;
    if (_error != error || _state != ViewModelState.done) {
      notify = true;
    }
    _error = error;
    _state = ViewModelState.done;

    if (notify) {
      notifyListeners();
    }
  }

  /// 错误信息
  Object _error;

  Object get error => _error;

  bool get hasError => _error != null;

  set error(Object v) {
    if (_error != v) {
      _error = v;
      notifyListeners();
    }
  }
}
