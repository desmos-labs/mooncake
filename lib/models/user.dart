import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Contains the data of a user.
class User implements Equatable {
  final String address;
  final String username;
  final String avatarUrl;

  bool get hasUsername => username != null && username.isNotEmpty;
  bool get hasAvatar => avatarUrl != null && avatarUrl.isNotEmpty;

  User({
    @required this.address,
    @required this.username,
    @required this.avatarUrl,
  })  : assert(address != null),
        assert(address.isNotEmpty);

  @override
  List<Object> get props => [address, username, avatarUrl];

  @override
  String toString() => 'User: { '
      'address: $address, '
      'username: $username, '
      'avatarUrl : $avatarUrl '
      '}';
}
