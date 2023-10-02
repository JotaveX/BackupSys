import 'dart:io';

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