import 'package:flutter/material.dart';

class CheckBoxButton extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final Widget child;

  const CheckBoxButton({
    Key key,
    this.value = false,
    @required this.onChanged,
    this.child = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: value,
              onChanged: (value) => onChanged(value),
              checkColor: Colors.white,
              activeColor: Color(0xFF999999),
              focusColor: Color(0xFF999999),
              hoverColor: Color(0xFF999999),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
