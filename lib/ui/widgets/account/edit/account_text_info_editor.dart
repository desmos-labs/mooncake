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

    return Container(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            maxLength: 20,
            decoration: InputDecoration(
              labelText: PostsLocalizations.of(context).monikerLabel,
            ),
            onChanged: (value) => bloc.add(MonikerChanged(value)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: PostsLocalizations.of(context).nameLabel,
                  ),
                  onChanged: (value) => bloc.add(NameChanged(value)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: PostsLocalizations.of(context).surnameLabel,
                  ),
                  onChanged: (value) => bloc.add(SurnameChanged(value)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            maxLength: 200,
            decoration: InputDecoration(
              labelText: PostsLocalizations.of(context).bioLabel,
            ),
            onChanged: (value) => bloc.add(BioChanged(value)),
          ),
        ],
      ),
    );
  }
}
