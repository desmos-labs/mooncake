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

  const ReportPopupState({
    @required this.selectedValues,
    @required this.otherText,
  })  : assert(selectedValues != null),
        assert(otherText != null);

  factory ReportPopupState.initial() {
    return ReportPopupState(
      selectedValues: {
        ReportType.Spam: false,
        ReportType.SexuallyInappropriate: false,
        ReportType.ScamOrMisleading: false,
        ReportType.ViolentOrProhibited: false,
        ReportType.Other: false,
      },
      otherText: "",
    );
  }

  ReportPopupState copyWith({
    Map<ReportType, bool> selectedValues,
    String otherText,
  }) {
    return ReportPopupState(
      selectedValues: selectedValues ?? this.selectedValues,
      otherText: otherText ?? this.otherText,
    );
  }

  @override
  List<Object> get props => [selectedValues, otherText];
}
