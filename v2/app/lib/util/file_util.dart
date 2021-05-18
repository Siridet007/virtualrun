import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileUtil {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/my_file.txt');
  }

  Future<int> readFile() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 100;
    }
  }

  Future<File> writeFile(int content) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$content');
  }
}