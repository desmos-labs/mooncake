import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

class ShowMnemonicVisualiser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(PostsLocalizations.of(context).viewMnemonic),
      ),
      // body: BlocBuilder<MnemonicBloc, MnemonicState>(
      //   builder: (context, state) {
      //     return (MnemonicVisualizer(mnemonic: state.mnemonic));
      //   },
      // ),
      body: Container(
        child: Text('here'),
      ),
    );
  }
}
