import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mooncake/ui/ui.dart';
import 'widgets/export.dart';

/// Represents the main content of the recover account screen.
class RecoverAccountMainContent extends StatelessWidget {
  final double bottomPadding;
  final bool backupPhrase;

  const RecoverAccountMainContent({
    Key key,
    @required this.bottomPadding,
    this.backupPhrase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecoverAccountBloc, RecoverAccountState>(
      builder: (BuildContext context, RecoverAccountState state) {
        return ListView(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            bottom: bottomPadding + 16,
            right: 16,
          ),
          children: <Widget>[
            // Instructions
            Text(
              PostsLocalizations.of(context)
                  .translate(Messages.recoverAccountInstructions),
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Words column
            StaggeredGridView.countBuilder(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              itemCount: 24,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              itemBuilder: (BuildContext context, int index) {
                return MnemonicInputItem(index: index);
              },
            ),

            // Error message
            if (state.isMnemonicComplete && !state.isMnemonicValid)
              Text(
                PostsLocalizations.of(context)
                    .translate(Messages.recoverAccountInvalidMnemonic),
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Theme.of(context).errorColor),
              ),

            // TODO: Remove this
            if (kDebugMode)
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      child: Text(PostsLocalizations.of(context)
                          .translate(Messages.recoverAccountContinueButton)),
                      onPressed: () => _debugMnemonic(context),
                    ),
                  ),
                ],
              ),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                child: Text(PostsLocalizations.of(context)
                    .translate(Messages.recoverAccountContinueButton)),
                onPressed: () => _continueClicked(context),
                enabled: state.isMnemonicValid,
              ),
            ),
          ],
        );
      },
    );
  }

  void _debugMnemonic(BuildContext context) {
    // TODO: Remove this
    final bloc = BlocProvider.of<RecoverAccountBloc>(context);
    bloc.add(WordSelected('frown'));
    bloc.add(WordSelected('spike'));
    bloc.add(WordSelected('buyer'));
    bloc.add(WordSelected('diagram'));
    bloc.add(WordSelected('between'));
    bloc.add(WordSelected('output'));
    bloc.add(WordSelected('keep'));
    bloc.add(WordSelected('ask'));
    bloc.add(WordSelected('column'));
    bloc.add(WordSelected('wage'));
    bloc.add(WordSelected('kid'));
    bloc.add(WordSelected('layer'));
    bloc.add(WordSelected('nasty'));
    bloc.add(WordSelected('grab'));
    bloc.add(WordSelected('learn'));
    bloc.add(WordSelected('same'));
    bloc.add(WordSelected('morning'));
    bloc.add(WordSelected('fog'));
    bloc.add(WordSelected('mandate'));
    bloc.add(WordSelected('sphere'));
    bloc.add(WordSelected('cream'));
    bloc.add(WordSelected('focus'));
    bloc.add(WordSelected('sister'));
    bloc.add(WordSelected('lava'));
  }

  /// Handle the click on the continue button
  void _continueClicked(BuildContext context) {
    if (backupPhrase) {
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToHome());
    } else {
      BlocProvider.of<RecoverAccountBloc>(context).add(TurnOffBackupPopup());
      BlocProvider.of<NavigatorBloc>(context).add(NavigateToProtectAccount());
    }
  }
}
