import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/screens/user_account_edit_screen/blocs/export.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';

import '../../../../../mocks/mocks.dart';

class MockAccountBloc extends Mock implements AccountBloc {}

class MockNavigatorBloc extends Mock implements NavigatorBloc {}

class MockSaveAccountUseCase extends Mock implements SaveAccountUseCase {}

void main() {
  MockSaveAccountUseCase mockSaveAccountUseCase;
  MockNavigatorBloc mockNavigatorBloc;
  setUp(() {
    mockSaveAccountUseCase = MockSaveAccountUseCase();
    mockNavigatorBloc = MockNavigatorBloc();
  });

  group(
    'EditAccountBloc',
    () {
      EditAccountBloc editAccountBloc;

      MooncakeAccount userAccount = MooncakeAccount(
        profilePicUri: "https://example.com/avatar.png",
        moniker: "john-doe",
        cosmosAccount: cosmosAccount,
      );
      setUp(
        () {
          editAccountBloc = EditAccountBloc(
            account: userAccount,
            navigatorBloc: mockNavigatorBloc,
            saveAccountUseCase: mockSaveAccountUseCase,
          );
        },
      );

      final File imageAddedFile = File("assets/images/cry.png");
      blocTest(
        'CoverChanged: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          bloc.add(CoverChanged(imageAddedFile));
        },
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account:
                userAccount.copyWith(coverPicUrl: imageAddedFile.absolute.path),
            saving: false,
            savingError: null,
            showErrorPopup: false,
          ),
        ],
      );

      blocTest(
        'ProfilePicChanged: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          bloc.add(ProfilePicChanged(imageAddedFile));
        },
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
                profilePicUri: imageAddedFile.absolute.path),
            saving: false,
            savingError: null,
            showErrorPopup: false,
          ),
        ],
      );

      blocTest(
        'DTagChanged: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          bloc.add(DTagChanged("StrawberriesTakeOver"));
        },
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
              dtag: "StrawberriesTakeOver",
            ),
            saving: false,
            savingError: null,
            showErrorPopup: false,
          ),
        ],
      );

      blocTest(
        'DTagChanged: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          bloc.add(DTagChanged("StrawberriesTakeOver"));
        },
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
              dtag: "StrawberriesTakeOver",
            ),
            saving: false,
            savingError: null,
            showErrorPopup: false,
          ),
        ],
      );

      blocTest(
        'MonikerChanged: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          bloc.add(MonikerChanged("StrawberriesTakeOver"));
        },
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
              moniker: "StrawberriesTakeOver",
            ),
            saving: false,
            savingError: null,
            showErrorPopup: false,
          ),
        ],
      );

      blocTest(
        'BioChanged: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          bloc.add(BioChanged("StrawberriesTakeOver"));
        },
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
              bio: "StrawberriesTakeOver",
            ),
            saving: false,
            savingError: null,
            showErrorPopup: false,
          ),
        ],
      );

      blocTest(
        'SaveAccount: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          when(mockSaveAccountUseCase.save(any,
                  syncRemote: anyNamed("syncRemote")))
              .thenAnswer((_) => Future.value(AccountSaveResult.success()));
          bloc.add(MonikerChanged("StrawberriesTakeOver"));
          bloc.add(DTagChanged("StrawberriesTakeOver"));
          bloc.add(SaveAccount());
        },
        skip: 3,
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
              dtag: "StrawberriesTakeOver",
              moniker: "StrawberriesTakeOver",
            ),
            saving: true,
            savingError: null,
            showErrorPopup: false,
          ),
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
              dtag: "StrawberriesTakeOver",
              moniker: "StrawberriesTakeOver",
            ),
            saving: false,
            savingError: null,
            showErrorPopup: false,
          ),
        ],
      );

      blocTest(
        'HideErrorPopup: work properly',
        build: () async {
          return editAccountBloc;
        },
        act: (bloc) async {
          when(mockSaveAccountUseCase.save(any,
                  syncRemote: anyNamed("syncRemote")))
              .thenAnswer(
                  (_) => Future.value(AccountSaveResult.error("error")));
          bloc.add(MonikerChanged("StrawberriesTakeOver"));
          bloc.add(DTagChanged("StrawberriesTakeOver"));
          bloc.add(SaveAccount());
          bloc.add(HideErrorPopup());
        },
        skip: 5,
        expect: [
          EditAccountState(
            originalAccount: userAccount,
            account: userAccount.copyWith(
              dtag: "StrawberriesTakeOver",
              moniker: "StrawberriesTakeOver",
            ),
            saving: false,
            savingError: "error",
            showErrorPopup: false,
          ),
        ],
      );
    },
  );
}
