import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class ExportMnemonicButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _openExportPopup(BuildContext context) {
      BlocProvider.of<MnemonicBloc>(context).add(ShowExportPopup());
    }

    return Expanded(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          child: PrimaryButton(
            child: Text(PostsLocalizations.of(context)
                .translate(Messages.exportMnemonic)),
            onPressed: () => _openExportPopup(context),
          ),
        ),
      ),
    );
  }
}
