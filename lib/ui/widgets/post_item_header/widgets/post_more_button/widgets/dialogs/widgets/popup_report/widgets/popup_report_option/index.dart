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
    final Map<ReportType, String> options = {
      ReportType.Spam:
          PostsLocalizations.of(context).translate("reportPopupSpam"),
      ReportType.SexuallyInappropriate: PostsLocalizations.of(context)
          .translate("reportPopupSexuallyInappropriate"),
      ReportType.ScamOrMisleading:
          PostsLocalizations.of(context).translate("reportPopupScamMisleading"),
      ReportType.ViolentOrProhibited: PostsLocalizations.of(context)
          .translate("reportPopupViolentProhibited"),
      ReportType.Other:
          PostsLocalizations.of(context).translate("reportPopupOther"),
    };

    final text = options.values.toList()[index];
    final type = ReportType.values[index];

    return BlocBuilder<ReportPopupBloc, ReportPopupState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
