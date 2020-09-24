import 'package:flutter/material.dart';

class AccountTextInput extends StatefulWidget {
  final String label;
  final String value;
  final void Function(String) onChanged;
  final int maxLength;
  final String error;
  final bool enabled;
  final int maxLines;

  AccountTextInput({
    @required this.label,
    @required this.value,
    @required this.onChanged,
    this.maxLength = 100,
    this.error,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  _AccountTextInputState createState() => _AccountTextInputState();
}

class _AccountTextInputState extends State<AccountTextInput> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Theme.of(context).accentColor),
        ),
        TextField(
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          minLines: widget.maxLines,
          onChanged: widget.onChanged,
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.value ?? widget.label,
            errorText: widget.error,
          ),
        ),
      ],
    );
  }
}
