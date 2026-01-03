final testLogs = <String>[];

void tlog(String msg) {
  final line = '${DateTime.now().toIso8601String()} $msg';
  testLogs.add(line);
  // ignore: avoid_print
  print(line); 
}
