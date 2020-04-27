import 'package:flutter_test/flutter_test.dart';
import 'package:mooncake/entities/entities.dart';

void main() {
  group('containsFrom', () {
    test('should return true', () {
      final reactions = [
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: ":+1:",
        ),
        Reaction(
          user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: ":heart:",
        ),
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: ":watermelon:",
        ),
      ];

      final account = MooncakeAccount.local(
        "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
      );
      expect(reactions.containsFrom(account, ":+1:"), isTrue);
      expect(reactions.containsFrom(account, ":watermelon:"), isTrue);
    });

    test('should return false', () {
      final account = MooncakeAccount.local(
        "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
      );

      final emptyReactions = List<Reaction>();
      expect(emptyReactions.containsFrom(account, ":+1:"), isFalse);

      final reactions = [
        Reaction(
          user: User(address: "desmos1gxhn7cs4v3wy2z5ff296qvyd3fzggw9dkk2rmd"),
          value: ":+1:",
        ),
        Reaction(
          user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: ":heart:",
        ),
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: ":watermelon:",
        ),
      ];
      expect(reactions.containsFrom(account, ":+1:"), isFalse);
      expect(reactions.containsFrom(account, ":non-existing:"), isFalse);
    });
  });

  group('removeOrAdd', () {
    test('shouldBeAdded', () {
      final reactions = [
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: ":+1:",
        ),
        Reaction(
          user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: ":heart:",
        ),
      ];

      final account = MooncakeAccount.local(
        "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
      );
      final result = reactions.removeOrAdd(account, ":watermelon:");

      final expected = [
        Reaction(
          user: User(
            address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
          ),
          value: ":+1:",
        ),
        Reaction(
          user: User(
            address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u",
          ),
          value: ":heart:",
        ),
        Reaction(
          user: User(
            address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
          ),
          value: ":watermelon:",
        ),
      ];
      expect(result, equals(expected));
    });

    test('shouldBeRemoved', () {
      final reactions = [
        Reaction(
          user: User(
            address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
          ),
          value: ":+1:",
        ),
        Reaction(
          user: User(
            address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u",
          ),
          value: ":heart:",
        ),
        Reaction(
          user: User(
            address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
          ),
          value: ":watermelon:",
        ),
      ];

      final account = MooncakeAccount.local(
        "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r",
      );
      final result = reactions.removeOrAdd(account, ":watermelon:");

      final expected = [
        Reaction(
          user: User(address: "desmos12rhdh3muv0ndpm2p7ava2hcnh9t3wxrhw2yf0r"),
          value: ":+1:",
        ),
        Reaction(
          user: User(address: "desmos10kll2dl8klqwzgy2h6py7gryakamjdhkyl6w2u"),
          value: ":heart:",
        ),
      ];
      expect(result, equals(expected));
    });
  });
}
