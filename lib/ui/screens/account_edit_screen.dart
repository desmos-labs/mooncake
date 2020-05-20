import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class EditAccountScreen extends StatelessWidget {
  static const double COVER_HEIGHT = 160;
  static const double PICTURE_RADIUS = 40;
  static const double PADDING = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PostsLocalizations.of(context).editAccountScreenTitle),
        centerTitle: true,
      ),
      body: BlocProvider<EditAccountBloc>(
        create: (context) => EditAccountBloc.create(),
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AccountCoverImageEditor(height: COVER_HEIGHT),
                    AccountTextInfoEditor(
                      padding: EdgeInsets.only(
                        top: PICTURE_RADIUS + 8,
                        left: PADDING,
                        bottom: PADDING,
                        right: PADDING,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: PADDING),
                      child: PrimaryRoundedButton(
                        text: PostsLocalizations.of(context).saveAccountButton,
                        onPressed: () => _onSaveAccount(context),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: COVER_HEIGHT - PICTURE_RADIUS,
                  left: PADDING,
                  child: AccountProfileImageEditor(
                    radius: PICTURE_RADIUS,
                    border: PICTURE_RADIUS / 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onSaveAccount(BuildContext context) {
    BlocProvider.of<EditAccountBloc>(context).add(SaveAccount());
  }
}
