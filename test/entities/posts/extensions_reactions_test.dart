import 'package:test/test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('containsFrom', () {
    final account = MooncakeAccount.local(
      "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
    );
    final reactions = [
      Reaction(user: account, value: "👍"),
      Reaction(
        user: User.fromAddress("desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
        value: "❤",
      ),
      Reaction(user: account, value: "🍉"),
    ];

    test('should return true', () {
      expect(reactions.containsFrom(account, "👍"), isTrue);
      expect(reactions.containsFrom(account, "🍉"), isTrue);
    });

    test('should return false with empty list', () {
      final emptyReactions = List<Reaction>();
      expect(emptyReactions.containsFrom(account, "🍉"), isFalse);
    });

    test('should return false with wrong reaction or account', () {
      expect(reactions.containsFrom(account, "✔"), isFalse);
      expect(
        reactions.containsFrom(MooncakeAccount.local("address"), "👍"),
        isFalse,
      );
    });
  });

  group('containsFromAddress', () {
    final address = "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r";
    final reactions = [
      Reaction(user: User.fromAddress(address), value: "👍"),
      Reaction(
        user: User.fromAddress("desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
        value: "❤",
      ),
      Reaction(user: User.fromAddress(address), value: "🍉"),
    ];

    test('should return true', () {
      expect(reactions.containsFromAddress(address, "👍"), isTrue);
      expect(reactions.containsFromAddress(address, "🍉"), isTrue);
    });

    test('should return false with empty list', () {
      final emptyReactions = List<Reaction>();
      expect(emptyReactions.containsFromAddress(address, "🍉"), isFalse);
    });

    test('should return false with wrong reaction or address', () {
      expect(reactions.containsFromAddress(address, "✔"), isFalse);
      expect(reactions.containsFromAddress("address", "👍"), isFalse);
    });
  });

  group('removeOrAdd', () {
    final account = MooncakeAccount.local(
      "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
    );

    final reactions = [
      Reaction(user: account, value: "👍"),
      Reaction(
        user: User.fromAddress("desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
        value: "❤",
      ),
    ];

    test('should add missing reaction properly', () {
      final result = reactions.removeOrAdd(account, "🍉");

      final expected = [
        Reaction(user: account, value: "👍"),
        Reaction(
          user:
              User.fromAddress("desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: "❤",
        ),
        Reaction(user: account.toUser(), value: "🍉"),
      ];
      expect(result, equals(expected));
    });

    test('should remove missing reaction properly', () {
      final reactions = [
        Reaction(
          user:
              User.fromAddress("desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "👍",
        ),
        Reaction(
          user:
              User.fromAddress("desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: "❤",
        ),
        Reaction(
          user:
              User.fromAddress("desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "🍉",
        ),
      ];

      final account = MooncakeAccount.local(
        "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
      );
      final result = reactions.removeOrAdd(account, "🍉");

      final expected = [
        Reaction(
          user:
              User.fromAddress("desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "👍",
        ),
        Reaction(
          user:
              User.fromAddress("desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: "❤",
        ),
      ];
      expect(result, equals(expected));
    });
  });
}
