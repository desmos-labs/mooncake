import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/edit/export.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/widgets/account_edit_body/widgets/export.dart';
import 'package:mooncake/ui/ui.dart';

import '../../../../../../../mocks/mocks.dart';
import '../../../../../../helper.dart';

class MockEditAccountBloc extends MockBloc<EditAccountEvent, EditAccountState>
    implements EditAccountBloc {}

void main() {
  var userAccount = MooncakeAccount(
    profilePicUri: 'https://example.com/avatar.png',
    moniker: 'john-doe',
    cosmosAccount: cosmosAccount,
  );

  testWidgets('SetBiometricTitle: Displays correctly',
      (WidgetTester tester) async {
    var mockEditAccountBloc = MockEditAccountBloc();
    when(mockEditAccountBloc.state)
        .thenAnswer((_) => EditAccountState.initial(userAccount));
    await tester.pumpWidget(
      makeTestableWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<EditAccountBloc>(
              create: (_) => mockEditAccountBloc,
            ),
          ],
          child: AccountProfileImageEditor(size: 10, border: 1),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(AccountAvatar), findsOneWidget);
    expect(find.byIcon(MooncakeIcons.camera), findsOneWidget);
  });
}
