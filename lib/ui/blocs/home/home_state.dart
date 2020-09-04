import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';

@immutable
class HomeState extends Equatable {
  final AppTab activeTab;
  final bool showBackupPhrasePopup;
  final bool scrollToTop;

  HomeState({
    @required this.activeTab,
    @required this.showBackupPhrasePopup,
    @required this.scrollToTop,
  })  : assert(showBackupPhrasePopup != null),
        assert(activeTab != null),
        assert(scrollToTop != null);

  factory HomeState.initial() {
    return HomeState(
      showBackupPhrasePopup: false,
      activeTab: AppTab.home,
      scrollToTop: false,
    );
  }

  HomeState copyWith({
    final AppTab activeTab,
    bool showBackupPhrasePopup,
    bool scrollToTop,
  }) {
    return HomeState(
      activeTab: activeTab ?? this.activeTab,
      showBackupPhrasePopup:
          showBackupPhrasePopup ?? this.showBackupPhrasePopup,
      scrollToTop: scrollToTop ?? this.scrollToTop,
    );
  }

  @override
  String toString() => 'MnemonicState { '
      'activeTab: $activeTab '
      'showBackupPhrasePopup: $showBackupPhrasePopup '
      'scrollToTop: $scrollToTop '
      ' }';

  @override
  List<Object> get props {
    return [
      activeTab,
      showBackupPhrasePopup,
      scrollToTop,
    ];
  }
}
