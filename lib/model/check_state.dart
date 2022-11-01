import 'package:hive_flutter/hive_flutter.dart';

part 'check_state.g.dart';

@HiveType(typeId: 6)
class CheckState {
  @HiveField(1)
  late Map<String, List<Object>> state;

  CheckState(this.state);

  CheckState.empty() {
    state = <String, List<Object>>{};
  }

  CheckState.from(Map<String, List<Object>> _s) {
    state = _s;
  }

  void add(String id, Object value) {
    if (state.containsKey(id)) {
      if (!state[id]!.contains(value)) {
        state[id]!.add(value);
      }
    } else {
      state[id] = [value];
    }
  }

  void update(String id, List<Object> value) {
    state[id] = value;
  }

  void delete(String id, Object value) {
    if (state.containsKey(id)) {
      state[id]!.remove(value);
      if (state[id]!.isEmpty) {
        state.remove(id);
      }
    }
  }

  bool contains(String id, Object value) {
    if (state.containsKey(id)) {
      return state[id]!.contains(value);
    }
    return false;
  }

  void clear(String id) {
    if (state.containsKey(id)) {
      state.remove(id);
    }
  }

  List<Object> get(String id) {
    if (state.containsKey(id)) {
      return state[id]!;
    }
    return [];
  }

  bool get isEmpty => state.isEmpty;
}

Map<String, List<Object>> toMap(dynamic data) {
  if (data != null) {
    if (data is List) return {};
    final convertData = <String, List<Object>>{};
    for (var k in data.keys) {
      final values = <Object>[];
      for (var v in data[k]) {
        values.add(v);
      }
      convertData[k] = values;
    }
    return convertData;
  }
  return {};
}
