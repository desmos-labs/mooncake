import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import '../../../../blocs/export.dart';

/// Represents the input that is used by the user to write something about
/// the report.
class PopupReportTextInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportPopupBloc, ReportPopupState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: TextFormField(
            maxLines: 2,
            autofocus: false,
            onChanged: (value) {
              BlocProvider.of<ReportPopupBloc>(context)
                  .add(ChangeOtherText(value));
            },
            decoration: InputDecoration(
              hintText: PostsLocalizations.of(context)
                  .translate(Messages.reportPopupEditBotHint),
              border: OutlineInputBorder(),
            ),
          ),
        );
      },
    );
  }
}
