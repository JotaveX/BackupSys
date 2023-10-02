import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as path;
import "dart:convert";


List<String> getAllDirectory(Directory destination, Request request) {
  List<String> res = [];
  destination.listSync().forEach((entity) {
    String lastPath = entity.path.split('\\').last;
    if (entity is Directory) {
      res.add(lastPath);
      getAllDirectory(entity.absolute, request);
    } else if (entity is File) {
        res.add(lastPath);
    }
  });
  print(res);
  return res;
}

void delete(String destination) {
  final directory = Directory('C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\BackupSys\\backup\\$destination');
  if (!directory.existsSync()) {
    return;
  }

  directory.deleteSync(recursive: true);
  
}

void startBackup(String sourcePath, String destPath){
  final destDir = Directory(destPath);
  String lastPath = path.basename(sourcePath);

  if (!destDir.existsSync()) {
    destDir.createSync(recursive: true);
  }

  final backupDir = Directory(path.join(destPath, lastPath + '_backup'));
  if (!backupDir.existsSync()) {
    backupDir.createSync();
  }

  backupIncremental(sourcePath, backupDir.path);
}

void backupIncremental(String sourcePath, String destPath) {
  final sourceDir = Directory(sourcePath);
  final destDir = Directory(destPath);

  if (!destDir.existsSync()) {
    destDir.createSync(recursive: true);
  }

  if (!destDir.existsSync()) {
    destDir.createSync();
  }

  // Crie uma lista dos arquivos existentes no diretório de destino
  List<String> destFiles = destDir.listSync()
      .whereType<File>()
      .map((entity) => entity.path)
      .toList();

  for (final entity in sourceDir.listSync()) {
    if (entity is File) {
      final destFilePath = path.join(destDir.path, path.basename(entity.path));
      final destFile = File(destFilePath);

      // Verifique se o arquivo existe no diretório de destino
      if (destFiles.contains(destFilePath)) {
        destFiles.remove(destFilePath); // Remove o arquivo da lista
      }

      if (!destFile.existsSync() ||
          entity.lastModifiedSync().isAfter(destFile.lastModifiedSync())) {
        print('copy: $destFilePath');
        entity.copySync(destFilePath);
      }
    } else if (entity is Directory) {
      final destDirPath = path.join(destPath, path.basename(entity.path));
      backupIncremental(entity.path, destDirPath);
    }
  }

  // Apague os arquivos restantes no diretório de destino que não existem mais na origem
  for (final deletedFile in destFiles) {
    print('delete: $deletedFile');
    File(deletedFile).deleteSync();
  }
}

Response downloadDirectory(String destination) {
  final directory = Directory('C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\BackupSys\\backup\\$destination');
  if (!directory.existsSync()) {
    return Response.notFound('Directory not found');
  }

  final zipFilePath = 'C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\BackupSys\\zip\\$destination.zip'; 
  final encoder = ZipFileEncoder();
  encoder.create(zipFilePath);

  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File) {
      encoder.addFile(entity);
    } else if (entity is Directory) {
      encoder.addDirectory(entity);
    }
  }

  encoder.close();

  final zipFile = File(zipFilePath);
  final bytes = zipFile.readAsBytesSync();
  final fileName = path.basename(zipFile.path);

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/zip',
    'Content-Disposition': 'Content-Disposition: attachment; filename=$fileName'
  };

  return Response.ok(bytes, headers: headers);
}
