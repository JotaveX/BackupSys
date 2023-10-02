import 'package:backupsys/backupsys.dart' as backupsys;

void main(List<String> arguments) {
  final sourceDir = Directory('D:\\jvpil\\Download navega\\');
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

  backupsys.copyDirectory(sourceDir, destDir);

  print('Backup realizado com sucesso.');
}
