import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/localization/export.dart';
import 'package:mooncake/ui/ui.dart';

import 'popup_report_option.dart';
import 'popup_report_text_input.dart';

/// Represents the popup that is shown to the user when he wants to
/// report a single post.
class ReportPostPopup extends StatelessWidget {
  final Post post;

  const ReportPostPopup({
    Key key,
    @required this.post
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: MediaQuery.of(context).viewInsets,
                decoration: new BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        PostsLocalizations.of(context).reportPopupTitle,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _separator(),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ReportType.values.length,
                      separatorBuilder: (_, index) => _separator(),
                      itemBuilder: (_, index) {
                        return PopupReportOption(index: index);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          PopupReportTextInput(),
                          const SizedBox(height: 16),
                          PrimaryRoundedButton(
                            onPressed: () => _sendReport(context),
                            text: PostsLocalizations.of(context)
                                .reportPopupSubmit,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _separator() {
    return Container(width: double.infinity, height: 0.5, color: Colors.grey);
  }

  void _sendReport(BuildContext context) {
    BlocProvider.of<ReportPopupBloc>(context).add(SubmitReport());
    BlocProvider.of<NavigatorBloc>(context).add(GoBack());
  }
}
