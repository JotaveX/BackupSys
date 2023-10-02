import 'dart:io';
import 'package:shelf/shelf.dart';

void copyDirectory(Directory source, Directory destination) {
    source.listSync().forEach((entity) {
      print(entity.path);
      if (entity is Directory) {
        final newDirectory = Directory('${destination.path}/${entity.path.split('\\').last}');
        newDirectory.createSync();
        copyDirectory(entity.absolute, newDirectory.absolute);
      } else if (entity is File) {
        entity.copySync('${destination.path}/${entity.path.split('\\').last}');
      }
    });
}

List<String> getAllDirectory(Directory destination, Request request) {
  List<String> res = [];
  destination.listSync().forEach((entity) {
    if (entity is Directory) {
      res.add(entity.path);
      getAllDirectory(entity.absolute, request);
    } else if (entity is File) {
        res.add(entity.path);
    }
  });
  print(res);
  return res;
}

void delete(){
  print('delete');
}

void getOne(){
  print('getOne');
}

void update(){
  print('update');
}

void upload(String destination){
  print('upload');
}