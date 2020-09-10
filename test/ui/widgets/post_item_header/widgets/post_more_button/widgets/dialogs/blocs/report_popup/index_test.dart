import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/widgets/post_item_header/widgets/post_more_button/widgets/dialogs/blocs/export.dart';

import '../../../../../../../../../mocks/posts.dart';

class MockBlockUserUseCase extends Mock implements BlockUserUseCase {}

class MockReportPostUseCase extends Mock implements ReportPostUseCase {}

void main() {
  var mockBlockUserUseCase = MockBlockUserUseCase();
  var mockReportPostUseCase = MockReportPostUseCase();

  group(
    'ReportPopupBloc',
    () {
      ReportPopupBloc reportPopupBloc;

      setUp(
        () {
          reportPopupBloc = ReportPopupBloc(
            post: testPost,
            blockUserUseCase: mockBlockUserUseCase,
            reportPostUseCase: mockReportPostUseCase,
          );
        },
      );

      blocTest(
        'ToggleSelection: correctly updates tab',
        build: () {
          return reportPopupBloc;
        },
        act: (bloc) async {
          bloc.add(ToggleSelection(ReportType.ScamOrMisleading));
        },
        expect: [
          ReportPopupState(
            selectedValues: {
              ReportType.Spam: false,
              ReportType.SexuallyInappropriate: false,
              ReportType.ScamOrMisleading: true,
              ReportType.ViolentOrProhibited: false,
              ReportType.Other: false,
            },
            otherText: '',
            blockUser: false,
          ),
        ],
      );

      blocTest(
        'ChangeOtherText: correctly updates tab',
        build: () {
          return reportPopupBloc;
        },
        act: (bloc) async {
          bloc.add(ChangeOtherText('triggered'));
        },
        expect: [
          ReportPopupState(
            selectedValues: {
              ReportType.Spam: false,
              ReportType.SexuallyInappropriate: false,
              ReportType.ScamOrMisleading: false,
              ReportType.ViolentOrProhibited: false,
              ReportType.Other: false,
            },
            otherText: 'triggered',
            blockUser: false,
          ),
        ],
      );

      blocTest(
        'ToggleBlockUser: correctly updates tab',
        build: () {
          return reportPopupBloc;
        },
        act: (bloc) async {
          bloc.add(ToggleBlockUser(true));
        },
        expect: [
          ReportPopupState(
            selectedValues: {
              ReportType.Spam: false,
              ReportType.SexuallyInappropriate: false,
              ReportType.ScamOrMisleading: false,
              ReportType.ViolentOrProhibited: false,
              ReportType.Other: false,
            },
            otherText: '',
            blockUser: true,
          ),
        ],
      );

      blocTest(
        'SubmitReport: correctly updates tab',
        build: () {
          return reportPopupBloc;
        },
        act: (bloc) async {
          when(mockBlockUserUseCase.block(any))
              .thenAnswer((_) => Future.value(null));
          bloc.add(ToggleBlockUser(true));
          bloc.add(SubmitReport());
        },
        skip: 1,
        expect: [],
        verify: (_) async {
          verify(mockBlockUserUseCase.block(any)).called(1);
          verify(mockReportPostUseCase.send(any)).called(1);
        },
      );
    },
  );
}
