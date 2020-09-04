import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class NewPostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 7,
        left: 7,
        bottom: 7,
        right: 10,
      ),
      child: Material(
        shape: CircleBorder(),
        color: Colors.grey[700].withOpacity(0.5), // button color
        child: SizedBox(
          width: 35,
          height: 35,
          child: Icon(
            MooncakeIcons.draft,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
