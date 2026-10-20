import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:athletes_application/models/athlete_models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class MediaStorageService {
  MediaStorageService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  Directory? _mediaDir;

  Future<void> ensureReady() async {
    if (kIsWeb) return;
    try {
      final base = await getApplicationDocumentsDirectory();
      _mediaDir = Directory('${base.path}/passport_media');
      if (!_mediaDir!.existsSync()) {
        await _mediaDir!.create(recursive: true);
      }
    } catch (_) {
      _mediaDir = null;
    }
  }

  String newId() => _uuid.v4();

  Future<String> persistMedia(String sourcePath, MediaType type) async {
    if (kIsWeb || _mediaDir == null) return sourcePath;
    await ensureReady();
    if (_mediaDir == null) return sourcePath;
    final ext = type == MediaType.video ? 'mp4' : 'jpg';
    final dest = File('${_mediaDir!.path}/${newId()}.$ext');
    await File(sourcePath).copy(dest.path);
    return dest.path;
  }

  Future<void> deleteFile(String path) async {
    if (kIsWeb) return;
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
