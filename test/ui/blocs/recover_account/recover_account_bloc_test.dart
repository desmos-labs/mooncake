import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
// import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';
// import 'package:mooncake/ui/models/converters/export.dart';
import '../../../mocks/mocks.dart';

void main() {
  setUp(() {});

  group(
    'RecoverAccountBloc',
    () {
      RecoverAccountBloc recoverAccountBloc;

      setUp(
        () {
          recoverAccountBloc = RecoverAccountBloc();
        },
      );

      blocTest(
        'ResetRecoverAccountState: work properly',
        build: () async {
          return recoverAccountBloc;
        },
        act: (bloc) async {
          bloc.add(TypeWord(0, 'orange'));
          bloc.add(ResetRecoverAccountState());
        },
        skip: 2,
        expect: [
          RecoverAccountState(
            currentWordIndex: 0,
            wordsList: List(24),
            isMnemonicValid: false,
          ),
        ],
      );

      final List<String> typeWordsFirstTest = List(24);
      typeWordsFirstTest[0] = 'orange';
      final List<String> typeWordsSecondTest = List(24);
      typeWordsSecondTest[0] = 'orange';
      typeWordsSecondTest[1] = 'apple';
      blocTest(
        'TypeWord: work properly',
        build: () async {
          return recoverAccountBloc;
        },
        act: (bloc) async {
          bloc.add(TypeWord(0, 'orange'));
          bloc.add(TypeWord(1, 'apple'));
        },
        expect: [
          RecoverAccountState(
            currentWordIndex: 0,
            wordsList: typeWordsFirstTest,
            isMnemonicValid: false,
          ),
          RecoverAccountState(
            currentWordIndex: 1,
            wordsList: typeWordsSecondTest,
            isMnemonicValid: false,
          )
        ],
      );

      final List<String> wordSelectedFirstTest = List(24);
      wordSelectedFirstTest[0] = 'pineapple';
      blocTest(
        'WordSelected: work properly',
        build: () async {
          return recoverAccountBloc;
        },
        act: (bloc) async {
          bloc.add(WordSelected('pineapple'));
        },
        expect: [
          RecoverAccountState(
            currentWordIndex: 1,
            wordsList: wordSelectedFirstTest,
            isMnemonicValid: false,
          ),
        ],
      );

      blocTest(
        'ChangeFocus: work properly',
        build: () async {
          return recoverAccountBloc;
        },
        act: (bloc) async {
          bloc.add(ChangeFocus(5, 'pineapple'));
          bloc.add(ChangeFocus(7, 'pineapple'));
        },
        expect: [
          RecoverAccountState(
            currentWordIndex: 5,
            wordsList: List(24),
            isMnemonicValid: false,
          ),
          RecoverAccountState(
            currentWordIndex: 7,
            wordsList: List(24),
            isMnemonicValid: false,
          ),
        ],
      );
    },
  );
}
