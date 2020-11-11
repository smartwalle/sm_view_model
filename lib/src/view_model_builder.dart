import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_view_model/src/view_model.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  /// 用于构建新的 [T] 对象
  final T Function() create;

  /// 当 [T] 准备完成之后的回调函数
  final Function(T) onModelReady;

  /// 用于构建 [Widget]
  final Widget Function(BuildContext context, T model, Widget child) builder;

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

  @override
  void initState() {
    super.initState();

    /// 优先复用
    if (widget.reuse) {
      _model = Provider.of(context, listen: false);
    }

    /// 没有找到可复用的，则新建
    if (_model == null && widget.create != null) {
      _model = widget.create();
    }

    if (_model == null && widget.reuse == false) {
      _model = Provider.of(context, listen: false);
    }

    if (widget.onModelReady != null && _model != null) {
      widget.onModelReady(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(_model != null);

    if (widget.create != null) {
      if (widget.consumer) {
        return ChangeNotifierProvider<T>(
          create: (ctx) => _model,
          child: Consumer<T>(
            child: widget.child,
            builder: widget.builder,
          ),
        );
      }

      return ChangeNotifierProvider<T>(
        create: (ctx) => _model,
        child: widget.child,
        builder: (ctx, child) {
          return widget.builder(ctx, Provider.of(ctx, listen: false), child);
        },
      );
    }

    if (widget.consumer) {
      return Consumer<T>(
        child: widget.child,
        builder: widget.builder,
      );
    }

    return widget.builder(context, _model, widget.child);
  }
}
