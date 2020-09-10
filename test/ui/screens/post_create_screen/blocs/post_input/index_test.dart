import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/ui/screens/post_create_screen/blocs/export.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/entities/entities.dart';
import '../../../../../mocks/mocks.dart';

class MockNavigatorBloc extends Mock implements NavigatorBloc {}

class MockSavePostUseCase extends Mock implements SavePostUseCase {}

class MockCreatePostUseCase extends Mock implements CreatePostUseCase {}

class MockGetSettingUseCase extends Mock implements GetSettingUseCase {}

class MockSaveSettingUseCase extends Mock implements SaveSettingUseCase {}

void main() {
  MockNavigatorBloc mockNavigatorBloc;
  MockSavePostUseCase mockSavePostUseCase;
  MockCreatePostUseCase mockCreatePostUseCase;
  MockGetSettingUseCase mockGetSettingUseCase;
  MockSaveSettingUseCase mockSaveSettingUseCase;

  setUp(() {
    mockNavigatorBloc = MockNavigatorBloc();
    mockSavePostUseCase = MockSavePostUseCase();
    mockCreatePostUseCase = MockCreatePostUseCase();
    mockGetSettingUseCase = MockGetSettingUseCase();
    mockSaveSettingUseCase = MockSaveSettingUseCase();
  });

  group(
    'PostInputBloc',
    () {
      PostInputBloc postInputBloc;
      setUp(
        () {
          postInputBloc = PostInputBloc(
            parentPost: testPost,
            navigatorBloc: mockNavigatorBloc,
            savePostUseCase: mockSavePostUseCase,
            createPostUseCase: mockCreatePostUseCase,
            getSettingUseCase: mockGetSettingUseCase,
            saveSettingUseCase: mockSaveSettingUseCase,
          );
        },
      );

      blocTest(
        'ResetForm: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          bloc.add(MessageChanged('hello world'));
          bloc.add(ResetForm());
        },
        skip: 1,
        expect: [
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: true,
            medias: [],
            poll: null,
            saving: false,
            showPopup: false,
            willShowPopupAgain: true,
          )
        ],
      );

      blocTest(
        'MessageChanged: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          bloc.add(MessageChanged('hello world'));
        },
        expect: [
          PostInputState(
            parentPost: testPost,
            message: 'hello world',
            allowsComments: true,
            medias: [],
            poll: null,
            saving: false,
            showPopup: false,
            willShowPopupAgain: true,
          )
        ],
      );

      blocTest(
        'ToggleAllowsComments: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          bloc.add(ToggleAllowsComments());
        },
        expect: [
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: false,
            medias: [],
            poll: null,
            saving: false,
            showPopup: false,
            willShowPopupAgain: true,
          )
        ],
      );
      final imageAddedFile = File('assets/images/cry.png');
      final imagePostMedia = PostMedia(
        uri: imageAddedFile.absolute.path,
        mimeType: mime(imageAddedFile.absolute.path),
      );
      blocTest(
        'ImageAdded: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          bloc.add(ImageAdded(imageAddedFile));
          bloc.add(ImageAdded(imageAddedFile));
          bloc.add(ImageAdded(imageAddedFile));
        },
        expect: [
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: true,
            medias: [imagePostMedia],
            poll: null,
            saving: false,
            showPopup: false,
            willShowPopupAgain: true,
          )
        ],
      );

      blocTest(
        'ImageRemoved: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          bloc.add(ImageAdded(imageAddedFile));
          bloc.add(ImageRemoved(imagePostMedia));
        },
        expect: [
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: true,
            medias: [
              PostMedia(
                uri: imageAddedFile.absolute.path,
                mimeType: mime(imageAddedFile.absolute.path),
              ),
            ],
            poll: null,
            saving: false,
            showPopup: false,
            willShowPopupAgain: true,
          ),
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: true,
            medias: [],
            poll: null,
            saving: false,
            showPopup: false,
            willShowPopupAgain: true,
          )
        ],
      );

      blocTest(
        'PostInputPollEvent: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          bloc.add(CreatePoll());
        },
        expect: [
          isA<PostInputState>(),
        ],
      );

      blocTest(
        'ChangeWillShowPopup: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          when(mockSaveSettingUseCase.save(
            key: anyNamed('key'),
            value: anyNamed('value'),
          )).thenAnswer((_) => Future.value(null));
          bloc.add(ChangeWillShowPopup());
        },
        expect: [
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: true,
            medias: [],
            poll: null,
            saving: false,
            showPopup: false,
            willShowPopupAgain: false,
          )
        ],
      );

      blocTest(
        'SavePost: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          when(mockGetSettingUseCase.get(
            key: anyNamed('key'),
          )).thenAnswer((_) => Future.value(false));
          bloc.add(SavePost());
        },
        expect: [
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: true,
            medias: [],
            poll: null,
            saving: true,
            showPopup: false,
            willShowPopupAgain: true,
          )
        ],
      );

      blocTest(
        'HidePopup: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          when(mockGetSettingUseCase.get(
            key: anyNamed('key'),
          )).thenAnswer((_) => Future.value(true));
          bloc.add(SavePost());
          bloc.add(HidePopup());
        },
        skip: 1,
        expect: [
          PostInputState(
            parentPost: testPost,
            message: null,
            allowsComments: true,
            medias: [],
            poll: null,
            saving: true,
            showPopup: false,
            willShowPopupAgain: true,
          )
        ],
      );

      blocTest(
        'CreatePost: work properly',
        build: () {
          return postInputBloc;
        },
        act: (bloc) async {
          when(mockCreatePostUseCase.create(
                  message: anyNamed('message'),
                  allowsComments: anyNamed('allowsComments'),
                  parentId: anyNamed('parentId')))
              .thenAnswer((_) => Future.value(testPost));

          when(mockSavePostUseCase.save(any))
              .thenAnswer((_) => Future.value(null));

          when(mockNavigatorBloc.add(any))
              .thenAnswer((_) => Future.value(null));

          bloc.add(CreatePost());
        },
        skip: 1,
        expect: [],
        verify: (_) async {
          verify(mockNavigatorBloc.add(any)).called(1);
        },
      );
    },
  );
}
