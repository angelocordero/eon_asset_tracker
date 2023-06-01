class UserException implements Exception {
  UserException();

  final String _message = 'No User Found';

  void throwsException() {
    throw UserException();
  }

  @override
  String toString() {
    return _message;
  }
}
