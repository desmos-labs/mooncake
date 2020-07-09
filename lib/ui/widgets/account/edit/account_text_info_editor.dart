import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

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
              _buildEditor(
                context: context,
                maxLength: 20,
                label: PostsLocalizations.of(context).dtagLabel,
                value: state.account.dtag,
                enabled: state.canEditDTag,
                onChanged: (value) => bloc.add(DTagChanged(value)),
                error: state.isDTagValid
                    ? null
                    : PostsLocalizations.of(context).errorDTagInvalid,
              ),
              const SizedBox(height: 16),
              _buildEditor(
                context: context,
                maxLength: 20,
                label: PostsLocalizations.of(context).monikerLabel,
                value: state.account.moniker,
                onChanged: (value) => bloc.add(MonikerChanged(value)),
                error: state.isMonikerValid
                    ? null
                    : PostsLocalizations.of(context).errorMonikerInvalid,
              ),
              const SizedBox(height: 16),
              _buildEditor(
                context: context,
                maxLength: 200,
                value: state.account.bio,
                label: PostsLocalizations.of(context).bioLabel,
                onChanged: (value) => bloc.add(BioChanged(value)),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a [TextField] with the specified options.
  Widget _buildEditor({
    @required BuildContext context,
    @required String label,
    @required String value,
    @required Function(String) onChanged,
    int maxLength = 100,
    String error,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Theme.of(context).accentColor),
        ),
        TextField(
          enabled: enabled,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: value ?? label,
            errorText: error,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
