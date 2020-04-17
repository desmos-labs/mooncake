import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: LoadingIndicator(),
        ),
      ),
    );
  }
}
