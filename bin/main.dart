import 'dart:io';

void main() {
  final sourceDir = Directory('C:/Users/jvpil/Desktop/idle_master_extended_v1.10.0/');
  final destDir = Directory('C:/Users/jvpil/OneDrive/Documentos/Github/BackupSys/backup/');

    if (!sourceDir.existsSync()) {
        print('O diretório de origem não existe.');
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
        if (entity is File) {
            final fileName = entity.path.split('/').last;
            final destFile = File('${destination.path}/$fileName');
            print('Copying ${entity.path} to ${destFile.path}');
            entity.copySync(destFile.path);
        } else if (entity is Directory) {
            final subDir = Directory('${destination.path}/${entity.path.split('/').last}');
            print(subDir);
            subDir.createSync();
            copyDirectory(entity, subDir);
        }
    });
}