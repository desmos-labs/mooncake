import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/export.dart';
import 'widgets/export.dart';

/// Allows to edit the textual information of the user profile.
class AccountTextInfoEditor extends StatelessWidget {
  final EdgeInsets padding;

  const AccountTextInfoEditor({
    Key key,
    @required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instantiate the bloc here for later usage
    // ignore: close_sinks
    final bloc = BlocProvider.of<EditAccountBloc>(context);

    return BlocBuilder<EditAccountBloc, EditAccountState>(
      builder: (context, state) {
        return Container(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AccountTextInput(
                maxLength: 20,
                label: PostsLocalizations.of(context)
                    .translate(Messages.dtagLabel),
                value: state.account.dtag,
                enabled: state.canEditDTag,
                onChanged: (value) => bloc.add(DTagChanged(value)),
                error: state.isDTagValid
                    ? null
                    : PostsLocalizations.of(context)
                        .translate(Messages.errorDTagInvalid),
              ),
              SizedBox(height: ThemeSpaces.largeGutter),
              AccountTextInput(
                maxLength: 20,
                label: PostsLocalizations.of(context)
                    .translate(Messages.monikerLabel),
                value: state.account.moniker,
                onChanged: (value) => bloc.add(MonikerChanged(value)),
                error: state.isMonikerValid
                    ? null
                    : PostsLocalizations.of(context)
                        .translate(Messages.errorMonikerInvalid),
              ),
              SizedBox(height: ThemeSpaces.largeGutter),
              AccountTextInput(
                maxLength: 200,
                maxLines: 3,
                value: state.account.bio,
                label:
                    PostsLocalizations.of(context).translate(Messages.bioLabel),
                onChanged: (value) => bloc.add(BioChanged(value)),
              ),
            ],
          ),
        );
      },
    );
  }
}
