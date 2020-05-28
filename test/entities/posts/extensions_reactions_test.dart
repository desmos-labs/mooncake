import 'package:test/test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('containsFrom', () {
    final account = MooncakeAccount.local(
      "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
    );
    final reactions = [
      Reaction(
        user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
        value: "👍",
      ),
      Reaction(
        user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
        value: "❤",
      ),
      Reaction(
        user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
        value: "🍉",
      ),
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
      Reaction(
        user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
        value: "👍",
      ),
      Reaction(
        user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
        value: "❤",
      ),
      Reaction(
        user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
        value: "🍉",
      ),
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
      Reaction(
        user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
        value: "👍",
      ),
      Reaction(
        user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
        value: "❤",
      ),
    ];

    test('shouldBeAdded', () {
      final result = reactions.removeOrAdd(account, "🍉");

      final expected = [
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "👍",
        ),
        Reaction(
          user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: "❤",
        ),
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "🍉",
        ),
      ];
      expect(result, equals(expected));
    });

    test('shouldBeRemoved', () {
      final reactions = [
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "👍",
        ),
        Reaction(
          user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: "❤",
        ),
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "🍉",
        ),
      ];

      final account = MooncakeAccount.local(
        "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
      );
      final result = reactions.removeOrAdd(account, "🍉");

      final expected = [
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: "👍",
        ),
        Reaction(
          user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: "❤",
        ),
      ];
      expect(result, equals(expected));
    });
  });
}
