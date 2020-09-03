import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum ReportType {
  Spam,
  SexuallyInappropriate,
  ScamOrMisleading,
  ViolentOrProhibited,
  Other
}

class ReportPopupState extends Equatable {
  final Map<ReportType, bool> selectedValues;
  final String otherText;

  final bool blockUser;

  const ReportPopupState({
    @required this.selectedValues,
    @required this.otherText,
    @required this.blockUser,
  })  : assert(selectedValues != null),
        assert(otherText != null),
        assert(blockUser != null);

  factory ReportPopupState.initial() {
    return ReportPopupState(
      selectedValues: {
        ReportType.Spam: false,
        ReportType.SexuallyInappropriate: false,
        ReportType.ScamOrMisleading: false,
        ReportType.ViolentOrProhibited: false,
        ReportType.Other: false,
      },
      otherText: '',
      blockUser: false,
    );
  }

  ReportPopupState copyWith({
    Map<ReportType, bool> selectedValues,
    String otherText,
    bool blockUser,
  }) {
    return ReportPopupState(
      selectedValues: selectedValues ?? this.selectedValues,
      otherText: otherText ?? this.otherText,
      blockUser: blockUser ?? this.blockUser,
    );
  }

  @override
  List<Object> get props => [selectedValues, otherText, blockUser];
}
