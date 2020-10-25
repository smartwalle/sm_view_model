import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final Function(T) onModelReady;
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Widget child;

  ViewModelWidget({
    Key key,
    @required this.model,
    this.onModelReady,
    @required this.builder,
    this.child,
  })  : assert(builder != null),
        assert(model != null),
        super(key: key);

  @override
  _ViewModelWidgetState<T> createState() {
    return _ViewModelWidgetState<T>();
  }
}

class _ViewModelWidgetState<T extends ChangeNotifier> extends State<ViewModelWidget<T>> {
  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(widget.model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (ctx) => widget.model,
      child: Consumer<T>(
        child: widget.child,
        builder: widget.builder,
      ),
    );
  }
}
