import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../blocs/export.dart';

/// Represents a single report option.
class PopupReportOption extends StatelessWidget {
  final int index;

  const PopupReportOption({
    Key key,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final options = <ReportType, String>{
      ReportType.Spam:
          PostsLocalizations.of(context).translate(Messages.reportPopupSpam),
      ReportType.SexuallyInappropriate: PostsLocalizations.of(context)
          .translate(Messages.reportPopupSexuallyInappropriate),
      ReportType.ScamOrMisleading: PostsLocalizations.of(context)
          .translate(Messages.reportPopupScamMisleading),
      ReportType.ViolentOrProhibited: PostsLocalizations.of(context)
          .translate(Messages.reportPopupViolentProhibited),
      ReportType.Other:
          PostsLocalizations.of(context).translate(Messages.reportPopupOther),
    };

    final text = options.values.toList()[index];
    final type = ReportType.values[index];

    return BlocBuilder<ReportPopupBloc, ReportPopupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: CheckBoxButton(
            value: state.selectedValues[type],
            child: Text(text),
            onChanged: (value) => _triggerEvent(context, type),
          ),
        );
      },
    );
  }

  void _triggerEvent(BuildContext context, ReportType type) {
    BlocProvider.of<ReportPopupBloc>(context).add(ToggleSelection(type));
  }
}
