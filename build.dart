import 'dart:io';

Future<void> runCommand(String commandLine) async {
  final process = await Process.start(
    'bash',
    ['-c', commandLine],
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('Command failed: $commandLine (exit code $exitCode)');
  }
}

void main() async {
  // Check for pubspec.yaml in this folder
  final pubspecFile = File('pubspec.yaml');
  if (!await pubspecFile.exists()) {
    throw Exception('pubspec.yaml not found. Please ensure you are in the root directory.');
  }

  if (!await Directory('./web/wasm_build').exists()) {
    await Directory('./web/wasm_build').create(recursive: true);
  }

  print('Building...');

  // Run the Emscripten build
  await runCommand('emcc ./cpp/main.cpp -o ./web/wasm_build/engine.js -pthread');
}
