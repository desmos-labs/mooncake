import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

@immutable
class HomeState extends Equatable {
  final AppTab activeTab;
  final bool showBackupPhrasePopup;

  HomeState({
    @required this.activeTab,
    @required this.showBackupPhrasePopup,
  })  : assert(showBackupPhrasePopup != null),
        assert(activeTab != null);

  factory HomeState.initial() {
    return HomeState(
      showBackupPhrasePopup: false,
      activeTab: AppTab.home,
    );
  }

  HomeState copyWith({
    final AppTab activeTab,
    bool showBackupPhrasePopup,
  }) {
    return HomeState(
      activeTab: activeTab ?? this.activeTab,
      showBackupPhrasePopup:
          showBackupPhrasePopup ?? this.showBackupPhrasePopup,
    );
  }

  @override
  String toString() => 'MnemonicState { '
      'appTab: $activeTab '
      'showBackupPhrasePopup: $showBackupPhrasePopup '
      ' }';

  @override
  List<Object> get props {
    return [
      activeTab,
      showBackupPhrasePopup,
    ];
  }
}
