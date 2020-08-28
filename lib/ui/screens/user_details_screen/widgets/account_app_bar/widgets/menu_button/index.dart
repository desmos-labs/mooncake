import 'package:flutter/material.dart';
import 'package:mooncake/ui/ui.dart';

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      child: ClipOval(
        child: Material(
          color: Colors.grey[500].withOpacity(0.6), // button color
          child: InkWell(
            // splashColor: Colors.red, // inkwell color
            child: SizedBox(
                width: 10,
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
      ),
    );
  }
}
