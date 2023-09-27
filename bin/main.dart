import 'dart:io';

void main() {
  final sourceDir = Directory('C:\\Users\\jvpil\\OneDrive\\Documentos\\Github\\BackupSys\\TesteBackup\\');
  final destDir = Directory('C:/Users/jvpil/OneDrive/Documentos/Github/BackupSys/backup/');

  if (!sourceDir.existsSync()) {
    print('O diretório ${sourceDir} de origem não existe.');
    return;
  }

  if (!sourceDir.statSync().modeString().contains('r')) {
    print('Sem permissão de leitura para o diretório de origem.');
    return;
  }

  if (!destDir.existsSync()) {
    destDir.createSync(recursive: true);
  }

  copyDirectory(sourceDir, destDir);

  print('Backup realizado com sucesso.');
}

void copyDirectory(Directory source, Directory destination) {
    source.listSync().forEach((entity) {
      if (entity is Directory) {
        final newDirectory = Directory('${destination.path}/${entity.path.split('\\').last}');
        newDirectory.createSync();
        copyDirectory(entity.absolute, newDirectory.absolute);
      } else if (entity is File) {
        entity.copySync('${destination.path}/${entity.path.split('\\').last}');
      }
    });
}