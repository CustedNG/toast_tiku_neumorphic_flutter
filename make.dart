#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

const appName = 'ToastTiku';
const buildDataFilePath = 'lib/res/build_data.dart';
const apkPath = 'build/app/outputs/flutter-apk/app-release.apk';
const xcarchivePath = 'build/ios/archive/Runner.xcarchive';
const macosAppPath = 'build/macos/Build/Products/Release/toast_tiku.app';
var regiOSProjectVer = RegExp(r'CURRENT_PROJECT_VERSION = .+;');
var regiOSMarketVer = RegExp(r'MARKETING_VERSION = .+');
const iOSInfoPlistPath = 'ios/Runner.xcodeproj/project.pbxproj';
const macOSInfoPlistPath = 'macos/Runner.xcodeproj/project.pbxproj';
const skslFileSuffix = '.sksl.json';

const buildFuncs = {
  'ios': flutterBuildIOS,
  'android': flutterBuildAndroid,
};

int? build;

Future<int> getGitCommitCount() async {
  final result = await Process.run('git', ['log', '--oneline']);
  return (result.stdout as String)
      .split('\n')
      .where((line) => line.isNotEmpty)
      .length;
}

Future<void> writeStaicConfigFile(
    Map<String, dynamic> data, String className, String path) async {
  final buffer = StringBuffer();
  buffer.writeln('// This file is generated by ./make.dart');
  buffer.writeln('');
  buffer.writeln('class $className {');
  for (var entry in data.entries) {
    final type = entry.value.runtimeType;
    final value = json.encode(entry.value);
    buffer.writeln('  static const $type ${entry.key} = $value;');
  }
  buffer.writeln('}');
  await File(path).writeAsString(buffer.toString());
}

Future<int> getGitModificationCount() async {
  final result =
      await Process.run('git', ['ls-files', '-mo', '--exclude-standard']);
  return (result.stdout as String)
      .split('\n')
      .where((line) => line.isNotEmpty)
      .length;
}

Future<String> getFlutterVersion() async {
  final result =
      await Process.run('fvm', ['flutter', '--version'], runInShell: true);
  return (result.stdout as String);
}

Future<Map<String, dynamic>> getBuildData() async {
  final data = {
    'name': appName,
    'build': build,
    'engine': await getFlutterVersion(),
    'buildAt': DateTime.now().toString(),
    'modifications': await getGitModificationCount(),
  };
  return data;
}

String jsonEncodeWithIndent(Map<String, dynamic> json) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(json);
}

Future<void> updateBuildData() async {
  print('Updating BuildData...');
  final data = await getBuildData();
  print(jsonEncodeWithIndent(data));
  await writeStaicConfigFile(data, 'BuildData', buildDataFilePath);
}

Future<void> dartFormat() async {
  final result = await Process.run('dart', ['format', '.']);
  print('\n${result.stdout}');
  if (result.exitCode != 0) {
    print(result.stderr);
    exit(1);
  }
}

void flutterRun(String? mode) {
  Process.start('flutter', mode == null ? ['run'] : ['run', '--$mode'],
      mode: ProcessStartMode.inheritStdio, runInShell: true);
}

Future<void> flutterBuild(
    String source, String target, String buildType) async {
  final args = [
    'flutter',
    'build',
    buildType,
  ];
  // No sksl cache for macos
  if ('macos' != buildType) {
    args.add('--bundle-sksl-path=$buildType$skslFileSuffix');
  }
  final isAndroid = 'apk' == buildType;
  // [--target-platform] only for Android
  if (isAndroid) {
    args.addAll([
      '--target-platform=android-arm64',
      '--build-number=$build',
      '--build-name=1.0.$build',
    ]);
  }
  print('[$buildType]\nBuilding with args: ${args.join(' ')}');
  final buildResult = await Process.run('fvm', args, runInShell: true);
  final exitCode = buildResult.exitCode;

  if (exitCode == 0) {
    target = target.replaceFirst('build', build.toString());
    print('Copying from $source to $target');
    if (isAndroid) {
      await File(source).copy(target);
    } else {
      final result = await Process.run('cp', ['-r', source, target]);
      if (result.exitCode != 0) {
        print(result.stderr);
        exit(1);
      }
    }

    print('Done.\n');
  } else {
    print(buildResult.stdout);
    print(buildResult.stderr);
    print('\nBuild failed with exit code $exitCode');
    exit(exitCode);
  }
}

Future<void> flutterBuildIOS() async {
  await changeInfoPlistVersion();
  await flutterBuild(
      xcarchivePath, './release/${appName}_ios_build.xcarchive', 'ipa');
}

Future<void> flutterBuildMacOS() async {
  await changeInfoPlistVersion();
  await flutterBuild(
      macosAppPath, './release/${appName}_macos_build.app', 'macos');
}

Future<void> flutterBuildAndroid() async {
  await flutterBuild(apkPath, './release/${appName}_build_Arm64.apk', 'apk');
}

Future<void> changeInfoPlistVersion() async {
  for (final path in [iOSInfoPlistPath, macOSInfoPlistPath]) {
    final file = File(path);
    final contents = await file.readAsString();
    final newContents = contents
        .replaceAll(regiOSMarketVer, 'MARKETING_VERSION = 1.0.$build;')
        .replaceAll(regiOSProjectVer, 'CURRENT_PROJECT_VERSION = $build;');
    await file.writeAsString(newContents);
  }
}

void main(List<String> args) async {
  if (args.isEmpty) {
    print('No action. Exit.');
    return;
  }

  final command = args[0];

  switch (command) {
    case 'run':
      return flutterRun(args.length == 2 ? args[1] : null);
    case 'build':
      final stopwatch = Stopwatch()..start();
      build = await getGitCommitCount();
      await updateBuildData();
      await dartFormat();
      if (args.length > 1) {
        final platform = args[1];
        if (buildFuncs.keys.contains(platform)) {
          await buildFuncs[platform]!();
        } else {
          print('Unknown platform: $platform');
        }
        return;
      }
      for (final func in buildFuncs.values) {
        await func();
      }
      print('Build finished in ${stopwatch.elapsed}');
      return;
    default:
      print('Unsupported command: $command');
      return;
  }
}
