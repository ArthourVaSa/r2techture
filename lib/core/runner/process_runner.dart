import 'dart:io';

abstract class ProcessRunner {
  Future<Process> start(String command, List<String> arguments, {bool runInShell = true});
}
