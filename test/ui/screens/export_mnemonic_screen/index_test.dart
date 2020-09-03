import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import '../../helper.dart';

void main() {
  testWidgets('ExportMnemonicScreen: Displays export correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        child: ExportMnemonicScreen(
          mnemonicData: MnemonicData(
            ivBase64: '3H+Sr64FhLS1VLABqZQGnw==',
            encryptedMnemonicBase64:
                'INEDpERjqL8iu8XpUbr+/1vDOFI00sQmMWHRVCm4jFlhVLINWzoQupPyZr5cgx7Ny6Q1czlxiU6+bGIu3nwyPQ==',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(find.text('exportMnemonic'), findsOneWidget);
    expect(find.text('mnemonicExportShareButton'), findsOneWidget);
  });
}
