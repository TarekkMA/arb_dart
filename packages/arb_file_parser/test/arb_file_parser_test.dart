import 'package:arb_file_parser/arb_file_parser.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('test', () {
    final parsed = ArbFileParser().parse(file);
    final string = parsed.toString();
    print('1');
  });
}

const file = """
    {
  "counterAppBarTitle": "Counter",
  "@counterAppBarTitle": {
    "description": "Text shown in the AppBar of the Counter Page"
  },
  "test": "This {not_used} {a} should be a {  name}",
  "@test": {
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Mahmoud",
        "description": "cost presented with currency symbol"
      },
      "z": {}
    }
  },
  "nWombats": "{count,plural, =0{no wombats} other{{count} wombats}} ",
  "@nWombats": {
    "description": "A plural message",
    "placeholders": {
      "count": {}
    }
  },
  "genderSelect": "Hi {gender,select, female{girl} male{man} other{بسكلتة}}",
  "@genderSelect": {
    "placeholders": {
      "gender": {
        "type": "String"
      },
    }
  },
  "generalSelect": " سي{choice,select, a{2 {c}} b{33} c{42}} سي",
  "@generalSelect": {
    "placeholders": {
      "choice": {},
      "c": {}
    }
  },
  "nThings": "{count,plural, =0{no {thing}s {c2}} other{{count} {thing}s}}",
  "@nThings": {
    "description": "A plural message with an additional parameter",
    "placeholders": {
      "count": {
        "type": "int"
      },
      "c2": {
        "type": "int"
      },
      "thing": {
        "example": "wombat"
      }
    }
  }
}
""";
