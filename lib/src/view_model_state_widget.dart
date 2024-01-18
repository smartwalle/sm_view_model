import 'package:flutter/widgets.dart';
import 'package:sm_view_model/src/view_model_state.dart';

class KIViewModelStateWidget<T> extends StatelessWidget {
  const KIViewModelStateWidget({
    Key? key,
    required this.state,
    required this.builder,
    this.initial,
    this.loading,
    this.failure,
  }) : super(key: key);

  final KIViewModelState<T> state;

  /// 当 [KIViewModelState] 的 [state] 属性为 [KIViewModelStateType.finished] 时，会构建本方法返回的 [Widget]
  /// 当 [KIViewModelState] 的 [state] 属性不为 [KIViewModelStateType.finished]，但是没有提供相应状态的 [Widget]，也会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewModelState<T> state) builder;

  /// 当 [KIViewModelState] 的 [state] 属性为 [KIViewModelStateType.initial] 时，会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewModelState<T> state)? initial;

  /// 当 [KIViewModelState] 的 [state] 属性为 [KIViewModelStateType.loading] 时，会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewModelState<T> state)? loading;

  /// 当 [KIViewModelState] 的 [error] 属性不为 [null] 并且 [state] 属性为 [KIViewModelStateType.finished] 时，会优先构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, KIViewModelState<T> state, Object error)? failure;

  @override
  Widget build(BuildContext context) {
    if (state.isFailure && failure != null) {
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
