import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of the backup recovery screen.
class RestoreBackupState extends Equatable {
  final String backup;
  final String password;

  bool get isBackupValid {
    try {
      base64Decode(backup);
      return true;
    } catch (e) {
      return false;
    }
  }

  final bool isPasswordValid;

  final bool restoring;

  const RestoreBackupState({
    @required this.backup,
    @required this.password,
    @required this.isPasswordValid,
    @required this.restoring,
  });

  factory RestoreBackupState.initial() {
    return RestoreBackupState(
      backup: null,
      password: null,
      isPasswordValid: true,
      restoring: false,
    );
  }

  RestoreBackupState copyWith({
    String backup,
    String password,
    bool isPasswordValid,
    bool restoring,
  }) {
    return RestoreBackupState(
      backup: backup ?? this.backup,
      password: password ?? this.password,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      restoring: restoring ?? this.restoring,
    );
  }

  @override
  List<Object> get props {
    return [backup, password, isPasswordValid];
  }
}
