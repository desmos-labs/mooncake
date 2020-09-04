import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class UpdateTab extends HomeEvent {
  final AppTab tab;

  const UpdateTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}

class SignOut extends HomeEvent {
  final String address;
  SignOut(this.address);
  @override
  String toString() => 'SignOut';

  @override
  List<Object> get props => [address];
}

/// Tells a bloc to show mnemonic backup popup
class ShowBackupMnemonicPhrasePopup extends HomeEvent {}

/// Tells a bloc to hide mnemonic backup popup
class HideBackupMnemonicPhrasePopup extends HomeEvent {}

/// Tells a bloc to turn off mnemonic backup popup permission
class TurnOffBackupMnemonicPopupPermission extends HomeEvent {}

class SetScrollToTop extends HomeEvent {
  final bool scroll;
  SetScrollToTop(this.scroll);
  @override
  String toString() => 'ToggleScrollToTop';

  @override
  List<Object> get props => [scroll];
}
