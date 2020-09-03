import 'package:mooncake/ui/ui.dart';

/// Returns the String representing the user mnemonic that has either been
/// generated using the account creation feature, or that has been inserted
/// using the recovery account feature.
String getMnemonic(
  RecoverAccountState recoverAccountState,
  AccountState accountState,
) {
  if (accountState is AccountCreated) {
    return accountState.mnemonic.join(' ');
  }

  if (accountState is AccountCreatedWhileLoggedIn) {
    return accountState.mnemonic.join(' ');
  }

  return recoverAccountState.wordsList.join(' ');
}
