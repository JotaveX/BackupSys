import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:backupsys/backupsys.dart' as backupsys;
import 'dart:convert';

void main() async {
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_handleRequest);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Listening on ${server.address}:${server.port}');
}

Future<Response> _handleRequest(Request request) async {
  if (request.method == 'GET') {
    if (request.url.path == '' || request.url.path == '/') {
      List<String> res = backupsys.getAllDirectory(Directory('C:\\projetos\\BackupSys\\backup'), request);
      final jsonResponse = jsonEncode({'files': res});
      return Response.ok(jsonResponse, headers: {'content-type': 'application/json'});
    } else {
      final path = request.url.path;
      backupsys.upload(path); 
      return Response.ok('Function called for path: $path');
    }
  } else if (request.method == 'POST') {
    final pathPost = request.url.path;
    backupsys.copyDirectory(Directory('C:\\$pathPost'), Directory('C:\\projetos\\BackupSys\\backup')); 
    return Response.ok('Received POST request with body: $pathPost');
  } else if (request.method == 'PUT') {
    final pathPut = request.url.path;
    backupsys.update();
    return Response.ok('Received PUT request for path: $pathPut');
  } else if (request.method == 'DELETE') {
    final pathDelete = request.url.path;
    backupsys.delete();
    return Response.ok('Received DELETE request for path: $pathDelete');
  } else {
    return Response.notFound('Not found');
  }
}
