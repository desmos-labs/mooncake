import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';
import '../../blocs/export.dart';
import 'widgets/export.dart';

// import 'popup_report_option.dart';
// import 'popup_report_text_input.dart';

/// Represents the popup that is shown to the user when he wants to
/// report a single post.
class ReportPostPopup extends StatelessWidget {
  final Post post;

  const ReportPostPopup({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ReportPopupBloc, ReportPopupState>(
        builder: (context, state) {
          return Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: MediaQuery.of(context).viewInsets,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                    ),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _title(context),
                      _separator(context),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ReportType.values.length,
                        separatorBuilder: (_, index) {
                          return _separator(context);
                        },
                        itemBuilder: (_, index) {
                          return PopupReportOption(index: index);
                        },
                      ),
                      PopupReportTextInput(),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 10,
                        ),
                        child: _submitButton(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          bottom: 40,
                        ),
                        child: _blockUserAndReport(context, state),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Text(
        PostsLocalizations.of(context).translate(Messages.reportPopupTitle),
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _separator(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).colorScheme.onError,
    );
  }

  Widget _blockUserAndReport(BuildContext context, ReportPopupState state) {
    return SecondaryDarkButton(
      onPressed: () {
        BlocProvider.of<ReportPopupBloc>(context).add(ToggleBlockUser(true));
        _sendReport(context);
      },
      child: Text(
          PostsLocalizations.of(context).translate(Messages.reportAndBlock)),
    );
  }

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      onPressed: () => _sendReport(context),
      child: Text(
          PostsLocalizations.of(context).translate(Messages.reportPopupSubmit)),
    );
  }

  void _sendReport(BuildContext context) {
    BlocProvider.of<ReportPopupBloc>(context).add(SubmitReport());
    BlocProvider.of<NavigatorBloc>(context).add(GoBack());
  }
}
