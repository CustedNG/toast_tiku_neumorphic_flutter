extension StringX on String {
  bool get isHttpUrl => startsWith('http://') || startsWith('https://');
}
