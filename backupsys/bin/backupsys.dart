import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:backupsys/backupsys.dart' as backupsys;
import 'dart:convert';
import 'package:path/path.dart' as path;

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
      List<String> res = backupsys.getAllDirectory(Directory('C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\BackupSys\\backup'), request);
      final jsonResponse = jsonEncode({'files': res});
      return Response.ok(jsonResponse, headers: {'content-type': 'application/json'});
    } else {
      final path = request.url.path;
      print(path);
      return backupsys.downloadDirectory(path); 
    }
  } 
  else if (request.method == 'POST') {
    final requestBody = await request.readAsString();
    final bodyMap = jsonDecode(requestBody);
    final pathPost = request.url.path;
    String path = bodyMap['path'];
    path.replaceAll('\\', '\\\\');

    backupsys.startBackup(path, 'C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\BackupSys\\backup'); 
    return Response.ok('Received POST request for path: $pathPost');
  } 
  else if (request.method == 'PUT') {
    // Use o valor do corpo da requisição aqui
    final requestBody = await request.readAsString();
  final bodyMap = jsonDecode(requestBody);
    final path = bodyMap['path'];
    print(path);
    //backupsys.backupIncremental(body, 'C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\backup');
    return Response.ok('Received PUT request for path');
  } else if (request.method == 'DELETE') {
    final pathDelete = request.url.path;
    backupsys.delete(pathDelete);
    return Response.ok('Received DELETE request for path: $pathDelete');
  } else {
    return Response.notFound('Not found');
  }
}
