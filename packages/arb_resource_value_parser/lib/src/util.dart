import 'package:petitparser/petitparser.dart';

extension ResultExt on Result {
  String highlightPosition() {
    return buffer.substring(0, this.position) +
        "\$" +
        buffer.substring(this.position);
  }
}
