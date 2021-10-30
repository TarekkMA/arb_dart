import '../../arb_resource_value_parser.dart';

extension ResourceValueComponentPrinterX on MessageComponent {
  String toResourceValueString() => ResourceValueEmitter().emit(this);
}

class ResourceValueEmitter implements ResourceValueVisitor<StringSink> {
  String emit(MessageComponent message) {
    return visitMessageComponent(message).toString();
  }

  @override
  StringSink visitChoiceValue(ChoiceValue message, [StringSink? output]) {
    final out = output ??= StringBuffer();
    out.write(message.choice);
    out.write('{');
    visitMessageComponent(message.value, out);
    out.write('}');
    return out;
  }

  @override
  StringSink visitMessage(ResourceValue message, [StringSink? output]) {
    final out = output ??= StringBuffer();
    for (final part in message.parts) {
      visitMessageComponent(part, out);
    }
    return out;
  }

  @override
  StringSink visitParameterizedMessage(ParameterizedMessage message,
      [StringSink? output]) {
    final out = output ??= StringBuffer();
    out.writeAll([
      '{',
      message.parameter,
      '}',
    ]);
    return out;
  }

  @override
  StringSink visitPlainMessage(PlainResourceValue message,
      [StringSink? output]) {
    final out = output ??= StringBuffer();
    out.write(message.text);
    return out;
  }

  StringSink _visitGenericSelection(
      HasParameter parameter, String literal, HasChoices choices,
      [StringSink? output]) {
    final out = output ??= StringBuffer();
    out.writeAll([
      '{',
      parameter.parameter,
      ' ,',
      literal,
      ' ,',
    ]);
    for (final choice in choices.choices) {
      out.write(' ');
      visitChoiceValue(choice, out);
    }
    out.write('}');
    return out;
  }

  @override
  StringSink visitGenderMessage(GenderMessage message, [StringSink? output]) =>
      _visitGenericSelection(
        message,
        'select',
        message,
        output,
      );

  @override
  StringSink visitPluralMessage(PluralMessage message, [StringSink? output]) =>
      _visitGenericSelection(
        message,
        'select',
        message,
        output,
      );

  @override
  StringSink visitSelectMessage(SelectMessage message, [StringSink? output]) =>
      _visitGenericSelection(
        message,
        'select',
        message,
        output,
      );

  @override
  StringSink visitMessageComponent(MessageComponent message,
          [StringSink? output]) =>
      message.accept(this, output);
}
