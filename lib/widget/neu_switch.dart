import 'package:flutter/material.dart';
import 'package:toast_tiku/core/persistant_store.dart';

Widget buildSwitch(BuildContext context, StoreProperty<bool> prop,
    {Function(bool)? func}) {
  return ValueListenableBuilder(
    valueListenable: prop.listenable(),
    builder: (context, bool value, widget) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 27),
        child: Switch(
            value: value,
            onChanged: (val) {
              if (func != null) func(val);
              prop.put(val);
            }),
      );
    },
  );
}
