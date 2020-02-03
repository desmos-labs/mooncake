import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class RecoverPopup extends StatelessWidget {
  final String title;
  final String message;
  final bool loading;
  final Function onTap;

  const RecoverPopup({
    Key key,
    @required this.title,
    @required this.message,
    this.loading = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Color(0x90000000),
        child: Center(
          child: Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 16),
                  Text(message),
                  if (loading) _loadingIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingIndicator() {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        SizedBox(
          child: LoadingIndicator(),
          width: 20,
          height: 20,
        ),
      ],
    );
  }
}
