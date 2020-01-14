import 'package:mooncake/ui/keys/export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Represents the screen showing the user some statistics.
class Stats extends StatelessWidget {
  Stats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(key: PostsKeys.emptyStatsContainer);
  }
}
