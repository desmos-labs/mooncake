import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

class MockGenerateMnemonicUseCase extends Mock
    implements GenerateMnemonicUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockGetAccountUseCase extends Mock implements GetAccountUseCase {}

class MockRefreshAccountUseCase extends Mock implements RefreshAccountUseCase {}

class MockGetSettingUseCase extends Mock implements GetSettingUseCase {}

class MockSaveSettingUseCase extends Mock implements SaveSettingUseCase {}

class MockNavigatorBloc extends Mock implements NavigatorBloc {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  MockGenerateMnemonicUseCase mockGenerateMnemonicUseCase;
  MockLogoutUseCase mockLogoutUseCase;
  MockGetAccountUseCase mockGetAccountUseCase;
  MockRefreshAccountUseCase mockRefreshAccountUseCase;
  MockGetSettingUseCase mockGetSettingUseCase;
  MockSaveSettingUseCase mockSaveSettingUseCase;
  MockNavigatorBloc mockNavigatorBloc;
  MockFirebaseAnalytics mockFirebaseAnalytics;

  setUp(() {
    mockGenerateMnemonicUseCase = MockGenerateMnemonicUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetAccountUseCase = MockGetAccountUseCase();
    mockRefreshAccountUseCase = MockRefreshAccountUseCase();
    mockGetSettingUseCase = MockGetSettingUseCase();
    mockSaveSettingUseCase = MockSaveSettingUseCase();
    mockNavigatorBloc = MockNavigatorBloc();
    mockFirebaseAnalytics = MockFirebaseAnalytics();
  });

  group('AccountBloc', () {
    dynamic accountBloc;

    setUp(() {
      accountBloc = AccountBloc(
        generateMnemonicUseCase: mockGenerateMnemonicUseCase,
        logoutUseCase: mockLogoutUseCase,
        getUserUseCase: mockGetAccountUseCase,
        refreshAccountUseCase: mockRefreshAccountUseCase,
        getSettingUseCase: mockGetSettingUseCase,
        saveSettingUseCase: mockSaveSettingUseCase,
        navigatorBloc: mockNavigatorBloc,
        analytics: mockFirebaseAnalytics,
      );
    });

    blocTest(
      'emits [1] when CounterEvent.increment is added',
      // ignore: return_of_invalid_type_from_closure
      build: () => accountBloc,
      act: (bloc) => bloc.add(AccountEvent.CheckStatus()),
      expect: [1],
    );
    // test('initial state is 0', () {
    //   expect(accountBloc.state, 0);
    // });
    //   blocTest(
    //   'emits [WeatherLoading, WeatherLoaded] when successful',
    //   build: () {
    //     when(mockWeatherRepository.fetchWeather(any))
    //         .thenAnswer((_) async => weather);
    //     return WeatherBloc(mockWeatherRepository);
    //   },
    //   act: (bloc) => bloc.add(GetWeather('London')),
    //   expect: [WeatherInitial(), WeatherLoading(), WeatherLoaded(weather)],
    // );
  });
}
