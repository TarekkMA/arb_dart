import 'package:arb_resource_value_parser/src/types/resource_value.dart';

abstract class ResourceValueVisitor<T> {
  const ResourceValueVisitor._();

  T visitMessageComponent(
    MessageComponent message, [
    T? context,
  ]);

  T visitMessage(
    ResourceValue message, [
    T? context,
  ]);

  T visitPlainMessage(
    PlainResourceValue message, [
    T? context,
  ]);

  T visitParameterizedMessage(
    ParameterizedMessage message, [
    T? context,
  ]);

  T visitChoiceValue(
    ChoiceValue message, [
    T? context,
  ]);

  T visitPluralMessage(
    PluralMessage message, [
    T? context,
  ]);

  T visitGenderMessage(
    GenderMessage message, [
    T? context,
  ]);

  T visitSelectMessage(
    SelectMessage message, [
    T? context,
  ]);
}
