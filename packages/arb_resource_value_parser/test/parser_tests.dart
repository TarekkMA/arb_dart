import 'dart:io';

import 'package:arb_resource_value_parser/arb_resource_value_parser.dart';
import 'package:arb_resource_value_parser/src/parser/definition.dart';
import 'package:petitparser/petitparser.dart';
import 'package:petitparser/reflection.dart';
import 'package:test/test.dart';

extension on bool {
  void get expectedTrue => expect(this, true);
}

typedef StartSelector<T> = Parser<T> Function() Function(
  ArbResourceValueDefinition def,
);

Parser<ResourceValue> getMainParser() =>
    ArbResourceValueDefinition().build<ResourceValue>();

Parser<T> getPartParser<T>(
  StartSelector<T> startSelector,
) {
  final def = ArbResourceValueDefinition();
  final part = startSelector(def);
  return def.build(start: part);
}

void main() {
  test('detect common parser problems', () {
    expect(linter(getMainParser()), isEmpty);
  });

  group('main parser', () {
    test('empty', () {
      final input = '';
      final parser = getMainParser();
      final res = parser.parse(input);
      final str = res.value.toResourceValueString();
      expect(str, '');
    });

    test('plain', () {
      final input = 'My name is طارق, (Tarek in english)';
      final parser = getMainParser();
      final res = parser.parse(input);
      final str = res.value.toResourceValueString();
      expect(str, input);
    });
  });

  group('parts parsers', () {
    test('plural', () {
      final input = '{count , plural , =0{no wombats}}';
      final parser = getPartParser((def) => def.pluralMessage);
      final res = parser.parse(input);

      print('1');
    });

    test('permutationOf test', () {
      final parser = permutationOf([
        string('a'),
        string('b').optional(),
        string('c').optional(),
      ]).flatten();

      final res1 = parser.parse('abc')..isSuccess.expectedTrue;
      final res2 = parser.parse('cab')..isSuccess.expectedTrue;
      final res3 = parser.parse('b')..isFailure.expectedTrue;
      final res4 = parser.parse('a')..isSuccess.expectedTrue;
      final res5 = parser.parse('ac')..isSuccess.expectedTrue;
    });

    test('choice test', () {
      final parser = getPartParser((def) => def.choice);
      final res1 = parser.parse('key { val a}');
      expect(res1.value.choice, 'key');
      expect(res1.value.value.toResourceValueString(), ' val a');

      final res2 = parser.parse('    myKey{ val { placeholder } va2 }');
      expect(res2.value.choice, 'myKey');
      expect(
          res2.value.value.toResourceValueString(), ' val {placeholder} va2 ');
    });
  });
}
