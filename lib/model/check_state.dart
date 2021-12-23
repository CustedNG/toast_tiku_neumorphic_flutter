class CheckState {
  late Map<String, List<Object>> _state;
  Map<String, List<Object>> get state => _state;

  CheckState.empty() {
    _state = <String, List<Object>>{};
  }

  CheckState.from(Map<String, List<Object>> _s) {
    _state = _s;
  }

  void add(String id, Object value) {
    if (_state.containsKey(id)) {
      if (!_state[id]!.contains(value)) {
        _state[id]!.add(value);
      }
    } else {
      _state[id] = [value];
    }
  }

  void update(String id, List<Object> value) {
    _state[id] = value;
  }

  void delete(String id, Object value) {
    if (_state.containsKey(id)) {
      _state[id]!.remove(value);
      if (_state[id]!.isEmpty) {
        _state.remove(id);
      }
    }
  }

  bool contains(String id, Object value) {
    if (_state.containsKey(id)) {
      return _state[id]!.contains(value);
    }
    return false;
  }

  void clear(String id) {
    if (_state.containsKey(id)) {
      _state.remove(id);
    }
  }

  List<Object> get(String id) {
    if (_state.containsKey(id)) {
      return _state[id]!;
    }
    return [];
  }

  bool get isEmpty => _state.isEmpty;
}

Map<String, List<Object>>? toMap(dynamic data) {
  if (data != null) {
    if (data is List) return null;
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
}
