import 'package:arb_resource_value_parser/arb_resource_value_parser.dart';
import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart';
import 'package:petitparser/definition.dart';
import 'package:petitparser/petitparser.dart';
import 'package:trotter/trotter.dart' show Permutations;

Parser<List<T>> permutationOf<T>(List<Parser<T>> parsers) {
  final perm = Permutations(parsers.length, parsers);
  return perm().map((seq) {
    return seq.toSequenceParser();
  }).toChoiceParser();
}

Parser trimmedComma = char(',').trim();

extension on Iterable<ChoiceValue> {
  ChoiceValue? whereChoiceEquals(String choice) =>
      whereChoiceEqualsOneOf([choice]);

  ChoiceValue? whereChoiceEqualsOneOf(Iterable<String> choices) =>
      where((element) => choices.contains(element.choice)).firstOrNull;
}

class ArbResourceValueDefinition extends GrammarDefinition {
  @override
  Parser<ResourceValue> start() =>
      (ref0(message) | ref0(empty)).cast<ResourceValue>().end();

  Parser<ResourceValue> empty() => epsilon()
      .map((_) => (ResourceValueBuilder()..parts = ListBuilder()).build());

  Parser<ResourceValue> message() => (ref0(plain) |
          ref0(parameterized) |
          ref0(pluralMessage) |
          ref0(genderMessage) |
          ref0(selectMessage))
      .plus()
      .castList<Message>()
      .map((value) =>
          (ResourceValueBuilder()..parts = value.build().toBuilder()).build());

  Parser<PlainResourceValue> plain() => (char('{') | char('}'))
      .neg()
      .plus()
      .flatten()
      .map((value) => (PlainResourceValueBuilder()..text = value).build());

  Parser<ParameterizedMessage> parameterized() {
    return (char('{') & ref0(identifier) & char('}')).map((value) =>
        (ParameterizedMessageBuilder()..parameter = value[1]).build());
  }

  Parser<String> identifier() =>
      (letter() & (word() | char('_')).star()).flatten().trim();

  Parser<ChoiceValue> choice([Parser? expectedChoice]) {
    final choiceParser = (expectedChoice ?? ref0(identifier)).trim();
    return (choiceParser & char('{') & ref0(message) & char('}'))
        .map((value) => (ChoiceValueBuilder()
              ..choice = value[0]
              ..value = value[2])
            .build());
  }

  Parser<List<ChoiceValue>> expectedChoices(
    List<Parser> optional,
    List<Parser> required,
  ) {
    final optionalParsers = optional.map((c) => ref1(choice, c).optional());
    final requiredParsers = required.map((r) => ref1(choice, r));
    return permutationOf(optionalParsers.followedBy(requiredParsers).toList())
        .map((value) => value.whereNotNull().toList());
  }

  Parser<PluralMessage> pluralMessage() {
    return (char('{') &
            ref0(identifier) &
            trimmedComma &
            string('plural') &
            trimmedComma &
            ref2(
              expectedChoices,
              [
                (string('=0') | string('zero')).flatten(),
                (string('=1') | string('one')).flatten(),
                (string('=2') | string('two')).flatten(),
                string('few'),
                string('many'),
              ],
              [
                string('other'),
              ],
            ) &
            char('}'))
        .map((value) {
      final String name = value[1];
      final List<ChoiceValue> choices = value[5];
      return (PluralMessageBuilder()
            ..parameter = name
            ..zero = choices.whereChoiceEqualsOneOf(['=0', 'zero'])?.toBuilder()
            ..one = choices.whereChoiceEqualsOneOf(['=1', 'one'])?.toBuilder()
            ..two = choices.whereChoiceEqualsOneOf(['=2', 'two'])?.toBuilder()
            ..few = choices.whereChoiceEquals('few')?.toBuilder()
            ..many = choices.whereChoiceEquals('many')?.toBuilder()
            ..other = choices.whereChoiceEquals('other')!.toBuilder())
          .build();
    });
  }

  Parser<GenderMessage> genderMessage() {
    return (char('{') &
            ref0(identifier) &
            trimmedComma &
            string('select') &
            trimmedComma &
            ref2(
              expectedChoices,
              [
                string('male'),
                string('female'),
              ],
              [
                string('other'),
              ],
            ) &
            char('}'))
        .map((value) {
      final String name = value[1];
      final List<ChoiceValue> choices = value[5];
      return (GenderMessageBuilder()
            ..parameter = name
            ..male = choices.whereChoiceEquals('male')?.toBuilder()
            ..female = choices.whereChoiceEquals('female')?.toBuilder()
            ..other = choices.whereChoiceEquals('other')!.toBuilder())
          .build();
    });
  }

  Parser<SelectMessage> selectMessage() {
    return (char('{') &
            ref0(identifier) &
            trimmedComma &
            string('select') &
            trimmedComma &
            choice().repeat(2, unbounded) &
            char('}'))
        .map((value) {
      final String name = value[1];
      final List<ChoiceValue> choices = value[5];
      return (SelectMessageBuilder()
            ..parameter = name
            ..choices = choices.build().toBuilder())
          .build();
    });
  }
}
