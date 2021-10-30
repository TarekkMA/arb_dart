import 'dart:convert';

import 'package:arb_file_parser/src/models.dart';
import 'package:built_collection/built_collection.dart';

class ArbFileParser {

  ArbFile parse(String content) {
    final decoded = json.decode(content) as Map<String, dynamic>;
    return ArbFile(decoded.build());
  }
}
