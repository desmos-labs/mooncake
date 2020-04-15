import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import './bloc.dart';

class ReportPopupBloc extends Bloc<ReportPopupEvent, ReportPopupState> {
  static const REASONS = {
    ReportType.Spam: "it's spam",
    ReportType.SexuallyInappropriate: "it's sexually inappropriate",
    ReportType.ScamOrMisleading: "it's scam or misleading",
    ReportType.ViolentOrProhibited: "it's violent or misleading",
    ReportType.Other: "other"
  };

  final Post _post;

  ReportPopupBloc({@required Post post})
      : assert(post != null),
        _post = post;

  factory ReportPopupBloc.create(Post post) {
    return ReportPopupBloc(post: post);
  }

  @override
  ReportPopupState get initialState => ReportPopupState.initial();

  @override
  Stream<ReportPopupState> mapEventToState(ReportPopupEvent event) async* {
    if (event is ToggleSelection) {
      yield* _mapToggleSelectionToState(event);
    } else if (event is ChangeOtherText) {
      yield* _mapChangeOtherTextToState(event);
    } else if (event is SubmitReport) {
      await _handleSubmitReport();
    }
  }

  Stream<ReportPopupState> _mapToggleSelectionToState(
    ToggleSelection event,
  ) async* {
    final map = Map.fromEntries(state.selectedValues.entries);
    map[event.type] = !map[event.type];
    yield state.copyWith(selectedValues: map);
  }

  Stream<ReportPopupState> _mapChangeOtherTextToState(
    ChangeOtherText event,
  ) async* {
    yield state.copyWith(otherText: event.text);
  }

  Future<void> _handleSubmitReport() async {
    final currentState = state;
    final reasonsString = currentState.selectedValues.entries
        .map((entry) => entry.value ? REASONS[entry.key] : null)
        .where((value) => value != null)
        .join(", ");

    final emailText = """
Please review the following post.
Post id: ${_post.id}
Reason(s): $reasonsString
Additional notes: ${currentState.otherText}
    """;

    final email = Email(
      body: emailText,
      subject: 'Post report',
      recipients: ['report@forbole.com'],
    );

    await FlutterEmailSender.send(email);
  }
}
