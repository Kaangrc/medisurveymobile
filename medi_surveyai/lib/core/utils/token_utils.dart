import 'package:jwt_decoder/jwt_decoder.dart';

class TokenUtils {
  // Token'ın geçerliliğini kontrol et
  static bool isTokenValid(String token) {
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      print('[log] Token validation error: $e');
      return false;
    }
  }

  // Token'dan kullanıcı ID'sini al
  static String? getUserIdFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['id']?.toString();
    } catch (e) {
      print('[log] Get user ID from token error: $e');
      return null;
    }
  }

  // Token'dan kullanıcı rolünü al
  static String? getUserRoleFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['role'] ?? decodedToken['type'];
    } catch (e) {
      print('[log] Get user role from token error: $e');
      return null;
    }
  }

  // Token'dan kullanıcı tipini al
  static String? getUserTypeFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['type'];
    } catch (e) {
      print('[log] Get user type from token error: $e');
      return null;
    }
  }

  // Token'ın son kullanma tarihini al
  static DateTime? getTokenExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      print('[log] Get token expiration date error: $e');
      return null;
    }
  }

  // Token'ın kalan süresini al (saniye cinsinden)
  static int? getTokenRemainingTime(String token) {
    try {
      final expirationDate = JwtDecoder.getExpirationDate(token);
      if (expirationDate == null) return null;

      final now = DateTime.now();
      return expirationDate.difference(now).inSeconds;
    } catch (e) {
      print('[log] Get token remaining time error: $e');
      return null;
    }
  }

  // Token'ı decode et ve tüm bilgileri al
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      print('[log] Decode token error: $e');
      return null;
    }
  }
}
