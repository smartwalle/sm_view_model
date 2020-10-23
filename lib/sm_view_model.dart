import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewModelWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final Function(T) onModelReady;
  final Widget Function(BuildContext context, T model) builder;

  ViewModelWidget({
    Key key,
    @required this.model,
    this.onModelReady,
    @required this.builder,
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
      create: (ctx) {
        return widget.model;
      },
      child: Consumer<T>(
        builder: (BuildContext ctx, T value, Widget child) {
          return widget.builder(ctx, value);
        },
      ),
    );
  }
}
