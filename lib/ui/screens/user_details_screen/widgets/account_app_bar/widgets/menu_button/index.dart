import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class MenuButton extends StatelessWidget {
  // final Icon icon;
  // final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Material(
        shape: CircleBorder(),
        color: Colors.grey[700].withOpacity(0.5), // button color
        child: InkWell(
          child: SizedBox(
              width: 50,
              height: 50,
              child: Icon(
                MooncakeIcons.menu,
                color: Colors.white,
                size: 15,
              )),
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }
}
