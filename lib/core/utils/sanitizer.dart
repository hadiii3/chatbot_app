class InputSanitizer {
  InputSanitizer._();

  /// Removes common malicious characters and HTML/script tags from user input.
  static String sanitize(String input) {
    if (input.isEmpty) return input;
    // Remove script tags, HTML tags, and potentially dangerous characters.
    String clean = input.replaceAll(RegExp(r'<[^>]*>|&[a-zA-Z0-9#]+;'), '');
    clean = clean.replaceAll(
        RegExp(r'[' '"]'), ''); // Remove quotes that could break JSON/SQL
    return clean.trim();
  }

  /// Specialized sanitization for Student IDs (only digits)
  static String sanitizeId(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '').trim();
  }
}
