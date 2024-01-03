import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController {
  void updateUserPresence() {
    // Implement your logic here
  }
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController();
});
