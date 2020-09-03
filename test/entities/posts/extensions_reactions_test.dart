import 'package:test/test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('containsFrom', () {
    final account = MooncakeAccount.local(
      'desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r',
    );
    final reactions = [
      Reaction.fromValue('👍', account),
      Reaction.fromValue(
        '❤',
        User.fromAddress('desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u'),
      ),
      Reaction.fromValue('🍉', account),
    ];

    test('should return true', () {
      expect(reactions.containsFrom(account, '👍'), isTrue);
      expect(reactions.containsFrom(account, '🍉'), isTrue);
    });

    test('should return false with empty list', () {
      final emptyReactions = <Reaction>[];
      expect(emptyReactions.containsFrom(account, '🍉'), isFalse);
    });

    test('should return false with wrong reaction or account', () {
      expect(reactions.containsFrom(account, '✔'), isFalse);
      expect(
        reactions.containsFrom(MooncakeAccount.local('address'), '👍'),
        isFalse,
      );
    });
  });

  group('containsFromAddress', () {
    final address = 'desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r';
    final reactions = [
      Reaction.fromValue('👍', User.fromAddress(address)),
      Reaction.fromValue(
        '❤',
        User.fromAddress('desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u'),
      ),
      Reaction.fromValue('🍉', User.fromAddress(address)),
    ];

    test('should return true', () {
      expect(reactions.containsFromAddress(address, '👍'), isTrue);
      expect(reactions.containsFromAddress(address, '🍉'), isTrue);
    });

    test('should return false with empty list', () {
      final emptyReactions = <Reaction>[];
      expect(emptyReactions.containsFromAddress(address, '🍉'), isFalse);
    });

    test('should return false with wrong reaction or address', () {
      expect(reactions.containsFromAddress(address, '✔'), isFalse);
      expect(reactions.containsFromAddress('address', '👍'), isFalse);
    });
  });

  group('removeOrAdd', () {
    final account = MooncakeAccount.local(
      'desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r',
    );

    final reactions = [
      Reaction.fromValue('👍', account),
      Reaction.fromValue('❤',
          User.fromAddress('desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u')),
    ];

    test('should add missing reaction properly', () {
      final result = reactions.removeOrAdd(account, '🍉');

      final expected = [
        Reaction.fromValue('👍', account),
        Reaction.fromValue(
          '❤',
          User.fromAddress('desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u'),
        ),
        Reaction.fromValue('🍉', account.toUser()),
      ];
      expect(result, equals(expected));
    });

    test('should remove missing reaction properly', () {
      final reactions = [
        Reaction.fromValue(
          '👍',
          User.fromAddress('desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r'),
        ),
        Reaction.fromValue(
          '❤',
          User.fromAddress('desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u'),
        ),
        Reaction.fromValue(
          '🍉',
          User.fromAddress('desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r'),
        ),
      ];

      final account = MooncakeAccount.local(
        'desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r',
      );
      final result = reactions.removeOrAdd(account, '🍉');

      final expected = [
        Reaction.fromValue(
          '👍',
          User.fromAddress('desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r'),
        ),
        Reaction.fromValue(
          '❤',
          User.fromAddress('desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u'),
        ),
      ];
      expect(result, equals(expected));
    });
  });
}
