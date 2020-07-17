import 'package:equatable/equatable.dart';
import '../export.dart';

abstract class ReportPopupEvent extends Equatable {
  const ReportPopupEvent();
}

/// Tells the Bloc that the selection for the given [type] of
/// report should be changed in its value.
class ToggleSelection extends ReportPopupEvent {
  final ReportType type;

  ToggleSelection(this.type);

  @override
  List<Object> get props => [type];
}

/// Tells the Bloc that the "other" text value has changed to be [text].
class ChangeOtherText extends ReportPopupEvent {
  final String text;

  ChangeOtherText(this.text);

  @override
  List<Object> get props => [text];
}

/// Tells the Bloc that the selection for the user blocking option has changed.
class ToggleBlockUser extends ReportPopupEvent {
  final bool blockUser;

  ToggleBlockUser(this.blockUser);

  @override
  List<Object> get props => [blockUser];
}

/// Tells the Bloc that the report should be sent.
class SubmitReport extends ReportPopupEvent {
  @override
  List<Object> get props => [];
}
