import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_view_model/src/view_model.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  /// 用于构建新的 [T] 对象
  final T Function() create;

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

  /// 是否优先复用原有 [T]
  /// 如果为 true，则会优先查找到最近的可用的 [T]，当未找到可复用的 [T] 时，才会创建新的 [T]
  /// 如果为 false，则每次都会创建新的 [T]
  final bool reuse;

  ViewModelBuilder({
    Key key,
    this.create,
    this.onModelReady,
    this.child,
    @required this.builder,
    this.onError,
    this.onLoading,
    this.consumer = true,
    this.reuse = false,
  })  : assert(builder != null),
        super(key: key);

  @override
  _ViewModelBuilderState<T> createState() {
    return _ViewModelBuilderState<T>();
  }
}

class _ViewModelBuilderState<T extends ViewModel> extends State<ViewModelBuilder<T>> {
  T _model;
  bool _reused = false;

  @override
  void initState() {
    super.initState();

    /// 优先复用
    if (widget.reuse) {
      _model = this.findViewModel();

      if (_model != null) {
        _reused = true;
      }
    }

    /// 复用失败则新建
    if (_model == null && widget.create != null) {
      _model = widget.create();
    }

    /// 新建失败并且为不优先复用，则查找
    if (_model == null && widget.reuse == false) {
      _model = this.findViewModel();

      if (_model != null) {
        _reused = true;
      }
    }

    if (widget.onModelReady != null && _model != null) {
      widget.onModelReady(_model);
    }
  }

  T findViewModel() {
    T value;
    try {
      value = Provider.of(context, listen: false);
    } catch (err) {}
    return value;
  }

  @override
  Widget build(BuildContext context) {
    assert(_model != null);

    if (_reused == false) {
      if (widget.consumer) {
        return ChangeNotifierProvider<T>(
          create: (ctx) => _model,
          child: Consumer<T>(
            child: widget.child,
            // builder: widget.builder,
            builder: _build,
          ),
        );
      }

      return ChangeNotifierProvider<T>(
        create: (ctx) => _model,
        child: widget.child,
        builder: (ctx, child) {
          // return widget.builder(ctx, _model, child);
          return _build(ctx, _model, child);
        },
      );
    }

    if (widget.consumer) {
      return ChangeNotifierProvider.value(
        value: _model,
        child: Consumer<T>(
          child: widget.child,
          // builder: widget.builder,
          builder: _build,
        ),
      );
    }

    return ChangeNotifierProvider.value(
      value: _model,
      // child: widget.builder(context, _model, widget.child),
      child: _build(context, _model, widget.child),
    );
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
