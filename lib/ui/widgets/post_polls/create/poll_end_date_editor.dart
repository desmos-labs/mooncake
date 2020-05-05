import 'package:flutter/material.dart';
import 'package:mooncake/ui/localization/export.dart';

import 'common.dart';

/// Represents the editor that allows to change the poll end date.
class PollEndDateEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => _showDatePicker(context),
        child: Container(
          decoration: getInputDecoration(context),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  PostsLocalizations.of(context).pollEndDateText,
                  style: Theme.of(context).inputDecorationTheme.hintStyle,
                ),
              ),
              // TODO: Set the current date value
              Text("test"),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final currentDate = null; // TODO: Get value from Bloc
    final date = await showDatePicker(
      context: context,
      useRootNavigator: false,
      firstDate: DateTime(1900),
      initialDate: currentDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate ?? DateTime.now()),
      );
      print(DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ));
    } else {
      return currentDate;
    }
  }
}
