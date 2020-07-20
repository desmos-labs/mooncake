import 'package:equatable/equatable.dart';

/// Represents a generic even emitted from within the mnemonic restoring screen.
abstract class RestoreBackupEvent extends Equatable {
  const RestoreBackupEvent();

  @override
  List<Object> get props => [];
}

/// Tells the Bloc that the backup text has changed.
class BackupTextChanged extends RestoreBackupEvent {
  final String backup;

  BackupTextChanged(this.backup);

  @override
  List<Object> get props => [backup];
}

/// Tells the Bloc that the encryption password has changed.
class EncryptPasswordChanged extends RestoreBackupEvent {
  final String password;

  EncryptPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

/// Tells the Bloc that the user has clicked the restore backup button.
class RestoreBackup extends RestoreBackupEvent {}
