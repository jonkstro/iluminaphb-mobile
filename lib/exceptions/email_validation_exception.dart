class EmailValidationException implements Exception {
  final String msg;

  EmailValidationException({required this.msg});

  @override
  String toString() {
    return msg;
  }
}
