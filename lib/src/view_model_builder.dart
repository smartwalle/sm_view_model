import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_view_model/src/view_model.dart';

class ViewModelBuilder<T extends ViewModel> extends StatefulWidget {
  final T model;
  final Function(T) onModelReady;
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Widget child;
  final bool consumer;

  ViewModelBuilder({
    Key key,
    this.model,
    this.onModelReady,
    this.child,
    @required this.builder,
    this.consumer = true,
  })  : assert(builder != null),
        assert(model != null),
        super(key: key);

  @override
  _ViewModelBuilderState<T> createState() {
    print("createState");
    return _ViewModelBuilderState<T>();
  }
}

class _ViewModelBuilderState<T extends ViewModel> extends State<ViewModelBuilder<T>> {
  T _model;

  @override
  void initState() {
    _model = widget.model;

    print("init state");

    if (widget.onModelReady != null && _model != null) {
      widget.onModelReady(_model);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("====== ${_model}");

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
        return widget.builder(ctx, _model, child);
      },
    );
  }
}
