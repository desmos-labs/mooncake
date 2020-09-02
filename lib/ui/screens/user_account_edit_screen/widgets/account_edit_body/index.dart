import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/export.dart';
import 'widgets/export.dart';

class AccountEditorBody extends StatelessWidget {
  static const double COVER_HEIGHT = 160;
  static const double PICTURE_RADIUS = 40;
  static const double PADDING = 16;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      builder: (context, state) {
        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: Stack(
            children: [
              ListView(
                children: [
                  Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AccountCoverImageEditor(height: COVER_HEIGHT),
                          AccountTextInfoEditor(
                            padding: EdgeInsets.only(
                              top: PICTURE_RADIUS + 16,
                              left: PADDING,
                              bottom: PADDING,
                              right: PADDING,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: PADDING),
                            child: state.saving
                                ? LoadingIndicator()
                                : PrimaryButton(
                                    enabled: state.canSave,
                                    child: Text(
                                      PostsLocalizations.of(context).translate(
                                          Messages.saveAccountButton),
                                    ),
                                    onPressed: () => _onSaveAccount(context),
                                  ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                      Positioned(
                        top: COVER_HEIGHT - PICTURE_RADIUS,
                        left: PADDING,
                        child: AccountProfileImageEditor(
                          size: PICTURE_RADIUS * 2,
                          border: PICTURE_RADIUS / 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (state.showErrorPopup)
                AccountEditErrorPopup(error: state.savingError),
            ],
          ),
        );
      },
    );
  }

  void _onSaveAccount(BuildContext context) {
    // Hide the keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    BlocProvider.of<EditAccountBloc>(context).add(SaveAccount());
  }
}
