import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/localization/export.dart';
// import 'package:mooncake/ui/ui.dart';

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
                      _separator(),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ReportType.values.length,
                        separatorBuilder: (_, index) {
                          return _separator();
                        },
                        itemBuilder: (_, index) {
                          return PopupReportOption(index: index);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: PopupReportTextInput(),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: _submitButton(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: _blockUserOption(context, state),
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
        PostsLocalizations.of(context).reportPopupTitle,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _separator() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: Color(0xFFECECEC),
    );
  }

  Widget _blockUserOption(BuildContext context, ReportPopupState state) {
    return CheckBoxButton(
      value: state.blockUser,
      child: Text(PostsLocalizations.of(context).reportPopupBlockUser),
      onChanged: (value) {
        BlocProvider.of<ReportPopupBloc>(context).add(ToggleBlockUser(value));
      },
    );
  }

  Widget _submitButton(BuildContext context) {
    return PrimaryButton(
      onPressed: () => _sendReport(context),
      child: Text(PostsLocalizations.of(context).reportPopupSubmit),
    );
  }

  void _sendReport(BuildContext context) {
    BlocProvider.of<ReportPopupBloc>(context).add(SubmitReport());
    BlocProvider.of<NavigatorBloc>(context).add(GoBack());
  }
}
