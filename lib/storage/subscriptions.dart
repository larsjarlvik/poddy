import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:poddy/models/podcast.dart';

const String _fileName = 'subscriptions.json';

Future<File> get _localFile async {
  final path = await getApplicationDocumentsDirectory();
  return new File('$path/$_fileName');
}

save(List<Podcast> podcasts) async {
  final encoded = json.encode(podcasts);
  final file = await _localFile;

  file.writeAsString(encoded);
}

Future<List<Podcast>> read() async {
  final file = await _localFile;
  final exists = await file.exists();

  if (!exists) return new List<Podcast>();

  final encoded = await file.readAsString();
  return json.decode(encoded);
}