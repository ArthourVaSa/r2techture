import 'dart:io';

abstract class ProcessRunner {
  Future<Process> start(String command, List<String> arguments, {bool runInShell = true});
}

class DefaultProcessRunner implements ProcessRunner {

  static final DefaultProcessRunner _instance = DefaultProcessRunner._internal();

  factory DefaultProcessRunner() => _instance;

  DefaultProcessRunner._internal();

  @override
  Future<Process> start(String command, List<String> arguments, {bool runInShell = true}) {
    return Process.start(command, arguments, runInShell: runInShell);
  }
}