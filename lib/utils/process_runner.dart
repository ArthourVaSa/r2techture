import 'dart:io';

abstract class ProcessRunner {
  Future<Process> start(String command, List<String> arguments, {bool runInShell = true}) {
    return Process.start(command, arguments, runInShell: runInShell);
  }
}

class DefaultProcessRunner implements ProcessRunner {
  @override
  Future<Process> start(String command, List<String> arguments, {bool runInShell = true}) {
    return Process.start(command, arguments, runInShell: runInShell);
  }
}