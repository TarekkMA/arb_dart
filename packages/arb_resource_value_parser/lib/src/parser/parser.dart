import 'package:arb_resource_value_parser/src/parser/definition.dart';

import '../../arb_resource_value_parser.dart';

class ArbResourceValueParser {
  final _parser = ArbResourceValueDefinition().build<ResourceValue>();

  ResourceValue parse(String input) => _parser.parse(input).value;
}
