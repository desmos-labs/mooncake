import 'package:flutter_email_sender/flutter_email_sender.dart';

/// Sends and email about a post reported
class ReportPostUseCase {
  /// Syncs the locally stored data to the chain.
  Future<void> send(Email email) async {
    await FlutterEmailSender.send(email);
  }
}
