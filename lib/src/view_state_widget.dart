import 'package:flutter/widgets.dart';
import 'package:sm_view_state/src/view_state.dart';

class KIViewStateWidget<T> extends StatelessWidget {
  const KIViewStateWidget({
    Key? key,
    required this.state,
    required this.builder,
    this.initial,
    this.loading,
    this.failure,
  }) : super(key: key);

  final KIViewState<T> state;

  /// 当 [KIViewState] 的 [state] 属性为 [KILoadState.finished] 时，会构建本方法返回的 [Widget]
  /// 当 [KIViewState] 的 [state] 属性不为 [KILoadState.finished]，但是没有提供相应状态的 [Widget]，也会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewState<T> state) builder;

  /// 当 [KIViewState] 的 [state] 属性为 [KILoadState.initial] 时，会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewState<T> state)? initial;

  /// 当 [KIViewState] 的 [state] 属性为 [KILoadState.loading] 时，会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewState<T> state)? loading;

  /// 当 [KIViewState] 的 [error] 属性不为 [null] 并且 [state] 属性为 [KILoadState.finished] 时，会优先构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewState<T> state, Object error)? failure;

  @override
  Widget build(BuildContext context) {
    if (state.isFailed && failure != null) {
      return failure!(context, state, state.error!);
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
