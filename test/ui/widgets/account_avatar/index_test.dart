import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';

void main() {
  testWidgets('No avatar', (WidgetTester tester) async {
    final user = User.fromAddress('address');
    await tester.pumpWidget(AccountAvatar(user: user));

    expect(find.byType(CustomPaint), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.byType(CircleAvatar), findsNothing);
  });

  testWidgets('Remote avatar image', (WidgetTester tester) async {
    final user = User(
      address: 'address',
      profilePicUri: 'https://cutt.ly/wsrqodv',
    );
    await tester.pumpWidget(AccountAvatar(user: user));

    expect(find.byType(CustomPaint), findsNothing);
    expect(find.byWidgetPredicate((widget) {
      return widget is CachedNetworkImage &&
          widget.imageUrl == user.profilePicUri;
    }), findsOneWidget);
    expect(find.byType(CircleAvatar), findsNothing);
  });

  testWidgets('Local avatar', (WidgetTester tester) async {
    final user = User(
      address: 'address',
      profilePicUri: 'file:/home/user/image.png',
    );

    // MediaQuery is required as CircleAvatar requires it to be build correctly
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(),
      child: AccountAvatar(user: user),
    ));

    expect(find.byType(CustomPaint), findsNothing);
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.byWidgetPredicate((widget) {
      return widget is CircleAvatar &&
          widget.backgroundImage == FileImage(File(user.profilePicUri));
    }), findsOneWidget);
  });
}
