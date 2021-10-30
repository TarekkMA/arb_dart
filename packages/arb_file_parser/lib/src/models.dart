import 'package:arb_resource_value_parser/arb_resource_value_parser.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'models.g.dart';

abstract class RetainsOriginalProps {
  BuiltMap<String, dynamic> get originalProps;

  dynamic operator [](String key);
}

abstract class ArbPlaceholderDefinition
    implements
        Built<ArbPlaceholderDefinition, ArbPlaceholderDefinitionBuilder>,
        RetainsOriginalProps {
  String get name;

  String? get type => originalProps['type'];

  String? get format => originalProps['format'];

  String? get context => originalProps['context'];

  String? get description => originalProps['description'];

  String? get example => originalProps['example'];

  BuiltMap<String, Object>? get optionalParameters =>
      originalProps['optionalParameters'];

  @override
  BuiltMap<String, dynamic> get originalProps;

  ArbPlaceholderDefinition._();

  factory ArbPlaceholderDefinition(
    String name,
    BuiltMap<String, dynamic> originalProps,
  ) {
    return (ArbPlaceholderDefinitionBuilder()
          ..name = name
          ..originalProps = originalProps.toBuilder())
        .build();
  }

  factory ArbPlaceholderDefinition.builder(
          [void Function(ArbPlaceholderDefinitionBuilder) updates]) =
      _$ArbPlaceholderDefinition;

  @override
  dynamic operator [](String key) => originalProps[key];

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArbPlaceholderDefinition')
          ..add('name', name)
          ..add('context', context)
          ..add('description', description)
          ..add('type', type)
          ..add('format', format)
          ..add('optionalParameters', optionalParameters)
          ..add('originalProps', 'OMITTED'))
        .toString();
  }
}

abstract class ArbResourceAttributes
    implements
        Built<ArbResourceAttributes, ArbResourceAttributesBuilder>,
        RetainsOriginalProps {
  String get id;

  String? get context => originalProps['context'];

  String? get description => originalProps['description'];

  @memoized
  BuiltList<ArbPlaceholderDefinition>? get placeholders {
    final org = originalProps['placeholders'] as Map<String, dynamic>?;
    if (org == null) return null;
    return org.keys.map((name) {
      final placeholderOrg = org[name] as Map<String, dynamic>;
      return ArbPlaceholderDefinition(name, placeholderOrg.build());
    }).toBuiltList();
  }

  @override
  BuiltMap<String, dynamic> get originalProps;

  ArbResourceAttributes._();

  factory ArbResourceAttributes(
    String id,
    BuiltMap<String, dynamic> originalProps,
  ) {
    return (ArbResourceAttributesBuilder()
          ..id = id
          ..originalProps = originalProps.toBuilder())
        .build();
  }

  factory ArbResourceAttributes.builder(
          [void Function(ArbResourceAttributesBuilder) updates]) =
      _$ArbResourceAttributes;

  @override
  dynamic operator [](String key) => originalProps[key];

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArbResourceAttributes')
          ..add('id', id)
          ..add('context', context)
          ..add('description', description)
          ..add('placeholders', placeholders)
          ..add('originalProps', 'OMITTED'))
        .toString();
  }
}

abstract class ArbResource implements Built<ArbResource, ArbResourceBuilder> {
  String get id;

  ResourceValue get value;

  ArbResourceAttributes? get attributes;

  ArbResource._();

  factory ArbResource([void Function(ArbResourceBuilder) updates]) =
      _$ArbResource;

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArbResource')
          ..add('id', id)
          ..add('value', 'OMITTED')
          ..add('attributes', attributes))
        .toString();
  }
}

abstract class ArbFile
    implements Built<ArbFile, ArbFileBuilder>, RetainsOriginalProps {
  // global attributes
  String? get locale => originalProps['@@locale'];

  String? get context => originalProps['@@context'];

  String? get author => originalProps['@@author'];

  String? attribute(String key) => this['@@$key'];

  String? customAttribute(String key) => this['@@x-$key'];

  @memoized
  BuiltList<ArbResource> get resources {
    final parser = ArbResourceValueParser();
    return originalProps.keys.where((key) => !key.startsWith('@')).map((key) {
      final id = key;

      final attrsJson = originalProps['@$id'] as Map<String, dynamic>?;

      final value = parser.parse(originalProps[id]);
      final attrs = attrsJson == null
          ? null
          : ArbResourceAttributes(id, attrsJson.build());

      return (ArbResourceBuilder()
            ..id = id
            ..value = value.toBuilder()
            ..attributes = attrs?.toBuilder())
          .build();
    }).toBuiltList();
  }

  @override
  BuiltMap<String, dynamic> get originalProps;

  ArbFile._();

  factory ArbFile(BuiltMap<String, dynamic> originalProps) {
    return (ArbFileBuilder()..originalProps = originalProps.toBuilder())
        .build();
  }

  factory ArbFile.builder([void Function(ArbFileBuilder) updates]) = _$ArbFile;

  @override
  dynamic operator [](String key) => originalProps[key];

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ArbFile')
          ..add('locale', locale)
          ..add('context', context)
          ..add('author', author)
          ..add('resources', resources)
          ..add('originalProps', 'OMITTED'))
        .toString();
  }
}
