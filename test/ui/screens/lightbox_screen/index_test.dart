import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('accountAppBar: Displays export correctly',
      (WidgetTester tester) async {
    var mockNavigatorBloc = MockNavigatorBloc();

    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<NavigatorBloc>(
              create: (_) => mockNavigatorBloc,
            ),
          ],
          child: LightboxScreen(
            photos: [
              PostMedia(
                  mimeType: 'image/png', uri: 'https://example.com/image.png'),
            ],
            selectedIndex: 0,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 3));
    expect(find.byIcon(MooncakeIcons.cross), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.byType(Flex), findsOneWidget);
  });
}
