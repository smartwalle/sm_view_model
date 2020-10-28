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

    if (widget.model != null) {
      _model = widget.model;
    }

    if (_model == null) {
      _model = Provider.of(context, listen: false);
    }

    if (widget.onModelReady != null && _model != null) {
      widget.onModelReady(_model);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(_model != null);

    if (widget.model != null) {
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
