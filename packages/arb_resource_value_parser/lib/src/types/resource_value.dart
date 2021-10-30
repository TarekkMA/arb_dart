import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:collection/collection.dart';

import '../../arb_resource_value_parser.dart';

part 'resource_value.g.dart';

/// Represents a part of the resource value
abstract class MessageComponent {
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]);
}

/// Represents the whole or part of the resource value
abstract class Message implements MessageComponent {}

/// Indicates that the implementing type have parametrized input
abstract class HasParameter {
  const HasParameter._();
  String get parameter;
}

/// Indicates that the implementing type have multiple choices
abstract class HasChoices {
  const HasChoices._();

  BuiltList<ChoiceValue> get choices;
}

abstract class ResourceValue
    implements Built<ResourceValue, ResourceValueBuilder>, Message {
  BuiltList<Message> get parts;

  ResourceValue._();

  factory ResourceValue([void Function(ResourceValueBuilder) updates]) =
      _$ResourceValue;

  @override
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]) =>
      visitor.visitMessage(this, context);
}

abstract class ParameterizedMessage
    implements
        Built<ParameterizedMessage, ParameterizedMessageBuilder>,
        Message,
        HasParameter {
  @override
  String get parameter;

  ParameterizedMessage._();

  factory ParameterizedMessage(
          [void Function(ParameterizedMessageBuilder) updates]) =
      _$ParameterizedMessage;

  @override
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]) =>
      visitor.visitParameterizedMessage(this, context);
}

/// Contains only plain text.
abstract class PlainResourceValue
    implements Built<PlainResourceValue, PlainResourceValueBuilder>, Message {
  String get text;

  PlainResourceValue._();

  factory PlainResourceValue(
          [void Function(PlainResourceValueBuilder) updates]) =
      _$PlainResourceValue;

  @override
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]) =>
      visitor.visitPlainMessage(this, context);
}

/// Represents one choice along with its value, this is typically part of select
/// or plural resource values
abstract class ChoiceValue
    implements Built<ChoiceValue, ChoiceValueBuilder>, MessageComponent {
  String get choice;

  Message get value;

  ChoiceValue._();

  factory ChoiceValue([void Function(ChoiceValueBuilder) updates]) =
      _$ChoiceValue;

  @override
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]) =>
      visitor.visitChoiceValue(this, context);
}

abstract class PluralMessage
    implements
        Built<PluralMessage, PluralMessageBuilder>,
        Message,
        HasParameter,
        HasChoices {
  @override
  String get parameter;

  ChoiceValue? get zero;

  ChoiceValue? get one;

  ChoiceValue? get two;

  ChoiceValue? get few;

  ChoiceValue? get many;

  ChoiceValue get other;

  @override
  BuiltList<ChoiceValue> get choices =>
      [zero, one, two, few, many, other].whereNotNull().toBuiltList();

  PluralMessage._();

  factory PluralMessage([void Function(PluralMessageBuilder) updates]) =
      _$PluralMessage;

  @override
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]) =>
      visitor.visitPluralMessage(this, context);
}

abstract class GenderMessage
    implements
        Built<GenderMessage, GenderMessageBuilder>,
        Message,
        HasParameter,
        HasChoices {
  @override
  String get parameter;

  ChoiceValue? get male;

  ChoiceValue? get female;

  ChoiceValue get other;

  @override
  BuiltList<ChoiceValue> get choices =>
      [male, female, other].whereNotNull().toBuiltList();

  GenderMessage._();

  factory GenderMessage([void Function(GenderMessageBuilder) updates]) =
      _$GenderMessage;

  @override
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]) =>
      visitor.visitGenderMessage(this, context);
}

abstract class SelectMessage
    implements
        Built<SelectMessage, SelectMessageBuilder>,
        Message,
        HasParameter,
        HasChoices {
  @override
  String get parameter;

  @override
  BuiltList<ChoiceValue> get choices;

  SelectMessage._();

  factory SelectMessage([void Function(SelectMessageBuilder) updates]) =
      _$SelectMessage;

  @override
  R accept<R>(ResourceValueVisitor<R> visitor, [R? context]) =>
      visitor.visitSelectMessage(this, context);
}
