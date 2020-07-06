import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

import 'account_cover_image_editor.dart';
import 'account_profile_image_editor.dart';
import 'account_text_info_editor.dart';
import 'account_edit_error_popup.dart';

class AccountEditorBody extends StatelessWidget {
  static const double COVER_HEIGHT = 160;
  static const double PICTURE_RADIUS = 40;
  static const double PADDING = 16;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditAccountBloc, EditAccountState>(
      builder: (context, state) {
        return Stack(
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
                        const SizedBox(height: 16),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: PADDING),
                          child: state.saving
                              ? LoadingIndicator()
                              : PrimaryButton(
                                  enabled: state.canSave,
                                  child: Text(
                                    PostsLocalizations.of(context)
                                        .saveAccountButton,
                                  ),
                                  onPressed: () => _onSaveAccount(context),
                                ),
                        ),
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
