import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void unawaited(Future<void> future) {}

bool isDarkMode(BuildContext context) =>
    NeumorphicTheme.of(context)!.isUsingDark;

void showSnackBar(BuildContext context, Widget child) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: child));
