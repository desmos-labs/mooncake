import 'package:mooncake/ui/screens/export.dart';
import 'package:equatable/equatable.dart';

/// Represents a generic event that is emitted when the user wants to
/// navigate from a screen to another one.
abstract class NavigatorEvent extends Equatable {
  const NavigatorEvent();

  @override
  List<Object> get props => [];
}

/// Tells the bloc to navigate to the home screen.
class NavigateToHome extends NavigatorEvent {
  @override
  String toString() => 'NavigateToHome';
}

/// Tells the bloc to navigate to the screen that allows to recover
/// an existing account using a mnemonic phrase.
class NavigateToRecoverAccount extends NavigatorEvent {
  final RecoverAccountArguments args;

  NavigateToRecoverAccount({this.args});

  @override
  String toString() => 'NavigateToRecoverAccount';
}

/// Tells the bloc to navigate to the screen that allows to create
/// a new random mnemonic phrase.
class NavigateToCreateAccount extends NavigatorEvent {
  @override
  String toString() => 'NavigateToCreateAccount';
}
