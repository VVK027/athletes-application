// Mock REST API for Digital Athlete Passport sync.
//
// Run: dart run tool/passport_api_server.dart
// Then set SyncConfig.apiBaseUrl (use http://10.0.2.2:8080 on Android emulator).

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  final port = args.isNotEmpty ? (int.tryParse(args.first) ?? 8080) : 8080;
  final storePath = '${Directory.systemTemp.path}/passport_api_store.json';
  final store = _PassportStore(storePath);

  final router = Router()
    ..get('/health', (_) => Response.ok('ok'))
    ..get('/passports/<id>', (Request request, String id) {
      final doc = store.get(id);
      if (doc == null) {
        return Response.notFound(jsonEncode({'error': 'Not found'}));
      }
      return Response.ok(
        jsonEncode(doc),
        headers: {'Content-Type': 'application/json'},
      );
    })
    ..put('/passports/<id>', (Request request, String id) async {
      final body = await request.readAsString();
      final map = jsonDecode(body) as Map<String, dynamic>;
      if (map['athleteId'] != id) {
        return Response.forbidden('athleteId mismatch');
      }
      store.put(id, map);
      return Response.ok(
        jsonEncode({'ok': true, 'updatedAt': map['updatedAt']}),
        headers: {'Content-Type': 'application/json'},
      );
    });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  // ignore: avoid_print
  print('Passport API → http://127.0.0.1:${server.port}');
  // ignore: avoid_print
  print('Store file → $storePath');
}

class _PassportStore {
  _PassportStore(this.path) {
    _load();
  }

  final String path;
  final Map<String, Map<String, dynamic>> _data = {};

  void _load() {
    final file = File(path);
    if (!file.existsSync()) return;
    final raw = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    for (final entry in raw.entries) {
      _data[entry.key] = Map<String, dynamic>.from(entry.value as Map);
    }
  }

  void _persist() {
    File(path).writeAsStringSync(jsonEncode(_data));
  }

  Map<String, dynamic>? get(String id) => _data[id];

  void put(String id, Map<String, dynamic> doc) {
    _data[id] = doc;
    _persist();
  }
}
