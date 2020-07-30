import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'blocs/export.dart';
import 'widgets/export.dart';

/// Represents the screen that is used when editing the information
/// about the current user profile.
class EditAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PostsLocalizations.of(context)
            .translate(Messages.editAccountScreenTitle)),
        centerTitle: true,
      ),
      body: BlocProvider<EditAccountBloc>(
        create: (context) => EditAccountBloc.create(context),
        child: AccountEditorBody(),
      ),
    );
  }
}
