import 'package:mockito/mockito.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to easily mock a [NotificationsRepository] instance.
/// We define it to keep the code DRY and avoid duplicated.
class NotificationsRepositoryMock extends Mock
    implements NotificationsRepository {}
