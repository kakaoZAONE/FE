import 'package:flutter/foundation.dart';

/// 로그인 상태 (Mock)
///
/// 백엔드 인증 API가 확정되기 전까지 화면 흐름만 확인하기 위한 메모리 상태다.
/// 새로고침하면 로그아웃된다. 실제 연동 시 이 클래스의 [signIn] · [signUp]만 바꾼다.
/// (docs/API.md '인증' 참고)
class AuthState extends ChangeNotifier {
  AuthState._();

  static final instance = AuthState._();

  String? _email;
  String? _name;

  bool get isSignedIn => _email != null;
  String? get email => _email;
  String? get name => _name;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static bool isValidEmail(String value) =>
      _emailPattern.hasMatch(value.trim());

  /// 비밀번호 규칙: 8자 이상, 숫자 포함 (Figma 회원가입 안내 '8자 이상 숫자 입력')
  static bool isValidPassword(String value) =>
      value.length >= 8 && RegExp(r'\d').hasMatch(value);

  /// 성공하면 null, 실패하면 오류 문구
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    if (!isValidEmail(email)) return '올바른 이메일 주소를 입력해주세요.';
    if (password.isEmpty) return '비밀번호를 입력해주세요.';
    _email = email.trim();
    _name = _registered[_email] ?? _email!.split('@').first;
    notifyListeners();
    return null;
  }

  /// 이번 방문에서 가입한 계정의 기업명 (이메일 → 기업명)
  final _registered = <String, String>{};

  /// 계정을 만든다. 성공하면 null, 실패하면 오류 문구.
  ///
  /// Figma `D2-2 회원가입 후 로그인`처럼 가입만 하고 로그인은 하지 않는다
  /// (화면이 이메일을 채운 로그인 창을 이어서 띄운다).
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty) return '기업명을 입력해주세요.';
    if (!isValidEmail(email)) return '올바른 이메일 주소를 입력해주세요.';
    if (!isValidPassword(password)) return '비밀번호는 숫자를 포함해 8자 이상 입력해주세요.';
    _registered[email.trim()] = name.trim();
    return null;
  }

  void signOut() {
    _email = null;
    _name = null;
    notifyListeners();
  }
}
