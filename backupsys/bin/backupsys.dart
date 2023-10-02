import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:backupsys/backupsys.dart' as backupsys;


void main() async {
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_handleRequest);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Listening on ${server.address}:${server.port}');
}

Future<Response> _handleRequest(Request request) async {
  if (request.method == 'GET') {
      List<String> res = backupsys.getAllDirectory(Directory('C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\BackupSys\\backup'), request);
      return Response.ok(res.toString());
  } else if (request.method == 'POST') {
    final body = await request.readAsString();
    return Response.ok('Received POST request with body: $body');
  } else {
    return Response.notFound('Not found');
  }
}