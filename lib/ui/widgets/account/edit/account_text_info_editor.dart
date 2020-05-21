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
                label: PostsLocalizations.of(context).monikerLabel,
                value: state.account.moniker,
                onChanged: (value) => bloc.add(MonikerChanged(value)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildEditor(
                      context: context,
                      maxLength: 20,
                      label: PostsLocalizations.of(context).nameLabel,
                      value: state.account.name,
                      onChanged: (value) => bloc.add(NameChanged(value)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEditor(
                      context: context,
                      maxLength: 20,
                      value: state.account.surname,
                      label: PostsLocalizations.of(context).surnameLabel,
                      onChanged: (value) => bloc.add(SurnameChanged(value)),
                    ),
                  ),
                ],
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
    BuildContext context,
    String label,
    String value,
    Function(String) onChanged,
    int maxLength,
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
          maxLength: maxLength,
          decoration: InputDecoration(hintText: value ?? label),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
