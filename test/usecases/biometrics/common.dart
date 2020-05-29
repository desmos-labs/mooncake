import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';

/// Allows to mock a [LocalAuthentication] instance.
/// We declare it here cause it might be used by different usecases and
/// we want to prevent duplicated code.
class LocalAuthenticationMock extends Mock implements LocalAuthentication {}
