import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_view_model/src/view_model.dart';

class ViewModelSelector<T extends ViewModel> extends Selector0 {
  ViewModelSelector({
    Widget Function(BuildContext context, T model) builder,
  }) : super(
            selector: (ctx) => Provider.of<T>(ctx),
            builder: (ctx, value, child) {
              return builder(ctx, value);
            });
}
