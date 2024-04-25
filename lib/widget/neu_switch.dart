import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../core/persistant_store.dart';

Widget buildSwitch(BuildContext context, StoreProperty<bool> prop,
    {Function(bool)? func,}) {
  return ValueListenableBuilder(
    valueListenable: prop.listenable(),
    builder: (context, bool value, widget) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 27),
        child: NeumorphicSwitch(
            height: 27,
            value: value,
            onChanged: (val) {
              if (func != null) func(val);
              prop.put(val);
            },),
      );
    },
  );
}
