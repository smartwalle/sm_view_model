import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final Function(T) onModelReady;
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Widget child;

  ViewModelWidget({
    Key key,
    this.model,
    this.onModelReady,
    this.child,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  _ViewModelWidgetState<T> createState() {
    return _ViewModelWidgetState<T>();
  }
}

class _ViewModelWidgetState<T extends ChangeNotifier> extends State<ViewModelWidget<T>> {
  @override
  void initState() {
    T model = widget.model;

    if (model == null) {
      model = Provider.of<T>(this.context, listen: false);
    }

    if (widget.onModelReady != null && model != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model != null) {
      return ChangeNotifierProvider<T>(
        create: (ctx) => widget.model,
        child: Consumer<T>(
          child: widget.child,
          builder: widget.builder,
        ),
      );
    }
    return Consumer<T>(
      child: widget.child,
      builder: widget.builder,
    );
  }
}
