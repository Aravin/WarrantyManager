import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

// imgFullPath can be name.jpg or path/name.jpg
Future<File> saveBolbAsImage(Uint8List bolb, String imgFullPath) {
  return File(imgFullPath).writeAsBytes(bolb);
}

Future<String> saveBolbAsImagePath(Uint8List bolb) async {
  if (bolb.isEmpty) return '';

  final directory = await getApplicationDocumentsDirectory();

  Directory('${directory.path}/products/').createSync(recursive: true);

  final String img =
      '${directory.path}/products/${DateTime.now().millisecondsSinceEpoch}.jpg';
  await saveBolbAsImage(bolb, img);

  return img;
}

// imgFullPath can be name.jpg or path/name.jpg
Future<File> saveFilebAsImage(File file, String imgFullPath) {
  return file.copy(imgFullPath);
}

Future<String> saveFileAsImagePath(List<dynamic> file) async {
  if (file.isEmpty) return '';

  final directory = await getApplicationDocumentsDirectory();

  Directory('${directory.path}/products/').createSync(recursive: true);

  final String img =
      '${directory.path}/products/${DateTime.now().millisecondsSinceEpoch}.jpg';
  await saveFilebAsImage(file[0] as File, img);

  return img;
}
