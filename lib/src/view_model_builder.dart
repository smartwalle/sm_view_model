import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final Function(T) onModelReady;
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Widget child;

  ViewModelBuilder({
    Key key,
    this.model,
    this.onModelReady,
    this.child,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  _ViewModelBuilderState<T> createState() {
    return _ViewModelBuilderState<T>();
  }
}

class _ViewModelBuilderState<T extends ChangeNotifier> extends State<ViewModelBuilder<T>> {
  @override
  void initState() {
    super.initState();

    T model = widget.model;

    if (model == null) {
      model = Provider.of<T>(this.context, listen: false);
    }

    if (widget.onModelReady != null && model != null) {
      widget.onModelReady(model);
    }
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
