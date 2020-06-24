import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/usecases/usecases.dart';

/// Allows to retrieve the currently stored notifications as well as all
/// the notifications that are created during time.
class GetNotificationsUseCase {
  final NotificationsRepository _repository;

  GetNotificationsUseCase({
    @required NotificationsRepository repository,
  })  : assert(repository != null),
        _repository = repository;

  /// Returns the list of notifications that are currently available.
  Future<List<NotificationData>> single() {
    return _repository.getNotifications();
  }

  /// Returns a [Stream] that emits all the new notifications
  /// that are created during time.
  Stream<NotificationData> stream() {
    return _repository.liveNotificationsStream;
  }
}
