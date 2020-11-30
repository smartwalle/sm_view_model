import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_view_model/src/view_model.dart';

/// final exampleViewModel = ChangeNotifierProvider.autoDispose.call((ref) => ExampleViewModel());
///
/// Widget build(BuildContext context) {
///    return Scaffold(
///      body: ViewModelBuilder<ExampleViewModel>(
///        provider: exampleViewModel,
///        onModelReady: (model) {
///          Future.microtask(() => model.count = 10);
///        },
///        builder: (context, model, child) {
///          return Text("hello ${model.count}");
///        },
///      ),
///    );
///  }

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  final ProviderBase<Object, T> provider;

  /// 当 [T] 准备完成之后的回调函数
  final Function(T model) onModelReady;

  /// 用于构建 [Widget]
  final Widget Function(BuildContext context, T model, Widget child) builder;

  /// 当 [T] 的 [error] 属性不为 [null] 时，会优先构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, T model, Object error) onError;

  /// 当 [T] 的 [state] 属性为 [ViewModelState.loading] 时，会构建本方法返回的 [Widget]
  final Widget Function(BuildContext context, T model) onLoading;

  /// 将作为 [builder] 函数中的 child 参数
  final Widget child;

  /// 是否需要将 [builder] 函数返回的 [Widget] 放置在 [Consumer] 中
  final bool consumer;

  ViewModelBuilder({
    Key key,
    @required this.provider,
    @required this.builder,
    this.onModelReady,
    this.child,
    this.onError,
    this.onLoading,
    this.consumer = true,
  })  : assert(builder != null),
        super(key: key);

  @override
  _ViewModelBuilderState<T> createState() {
    return _ViewModelBuilderState<T>();
  }
}

class _ViewModelBuilderState<T extends ViewModel> extends State<ViewModelBuilder<T>> {
  T _model;

  @override
  void initState() {
    super.initState();

    _model = this.findViewModel();

    if (widget.onModelReady != null && _model != null) {
      widget.onModelReady(_model);
    }
  }

  T findViewModel() {
    T value;
    try {
      value = ProviderScope.containerOf(context, listen: false).read(widget.provider);
    } catch (err) {}
    return value;
  }

  @override
  Widget build(BuildContext context) {
    assert(_model != null);

    if (widget.consumer) {
      return Consumer(
        child: widget.child,
        builder: (context, watch, child) {
          var model = watch(widget.provider);
          return _build(context, model, child);
        },
      );
    }
    return _build(context, _model, widget.child);
  }

  Widget _build(BuildContext ctx, T model, Widget child) {
    if (model.hasError && widget.onError != null) {
      var errWidget = widget.onError(ctx, model, model.error);
      if (errWidget != null) {
        return errWidget;
      }
    }

    if (model.isLoading && widget.onLoading != null) {
      var loadingWidget = widget.onLoading(ctx, model);
      if (loadingWidget != null) {
        return loadingWidget;
      }
    }

    return widget.builder(ctx, model, child);
  }
}
