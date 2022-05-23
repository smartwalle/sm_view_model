import 'package:flutter/widgets.dart';
import 'package:sm_view_state/src/view_state.dart';

class ViewStateWidget<T> extends StatelessWidget {
  final ViewState<T> state;

  /// 当 [ViewState] 的 [state] 属性为 [LoadState.finished] 时，会构建本方法返回的 [Widget]
  /// 当 [ViewState] 的 [state] 属性不为 [LoadState.finished]，但是没有提供相应状态的 [Widget]，也会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, ViewState<T> state) builder;

  /// 当 [ViewState] 的 [state] 属性为 [LoadState.initial] 时，会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, ViewState<T> state)? initial;

  /// 当 [ViewState] 的 [state] 属性为 [LoadState.loading] 时，会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, ViewState<T> state)? loading;

  /// 当 [ViewState] 的 [error] 属性不为 [null] 时，会优先构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, Object error)? error;

  const ViewStateWidget({
    Key? key,
    required this.state,
    required this.builder,
    this.initial,
    this.loading,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.hasError && error != null) {
      return error!(context, state.error!);
    }
    if (state.isInitial && initial != null) {
      return initial!(context, state);
    }
    if (state.isLoading && loading != null) {
      return loading!(context, state);
    }
    return builder(context, state);
  }
}
