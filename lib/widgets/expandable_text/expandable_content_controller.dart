import 'package:get/get.dart';

class ExpandableContentController extends GetxController {
  ExpandableContentController({
    required String text,
    this.wordLimit = 30,
  }) : _text = text;

  final int wordLimit;
  final RxBool isExpanded = false.obs;

  String _text;

  bool get canExpand => _wordCount(_text) > wordLimit;

  String get visibleText {
    final normalized = _normalize(_text);
    if (!canExpand || isExpanded.value) return normalized;

    final words = normalized.split(' ');
    return words.take(wordLimit).join(' ');
  }

  void toggleExpanded() {
    isExpanded.toggle();
  }

  void updateText(String text) {
    if (_text == text) return;
    _text = text;
    isExpanded.value = false;
  }

  int _wordCount(String value) {
    final normalized = _normalize(value);
    if (normalized.isEmpty) return 0;
    return normalized.split(' ').length;
  }

  String _normalize(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
