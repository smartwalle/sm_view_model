import 'package:flutter/widgets.dart';
import 'package:sm_view_state/src/view_state.dart';

class ViewStateWidget<T> extends StatelessWidget {
  final ViewState<T> state;
  final Widget Function(BuildContext context, ViewState<T> state) builder;
  final Widget Function(BuildContext context, ViewState<T> state)? init;
  final Widget Function(BuildContext context, ViewState<T> state)? loading;
  final Widget Function(BuildContext context, Object error)? error;

  const ViewStateWidget({
    Key? key,
    required this.state,
    required this.builder,
    this.init,
    this.loading,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.isInit && init != null) {
      return init!(context, state);
    }
    if (state.isLoading && loading != null) {
      return loading!(context, state);
    }
    if (state.hasError && error != null) {
      return error!(context, state.error!);
    }
    return builder(context, state);
  }
}
