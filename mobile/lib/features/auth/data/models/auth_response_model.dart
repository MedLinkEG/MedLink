import 'package:medlink/core/network/api_constants.dart';
import 'package:medlink/features/auth/domain/entities/auth_session.dart';

class AuthResponseModel {
  const AuthResponseModel({required this.accessToken, required this.tokenType});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String? ?? ApiConstants.defaultTokenType,
    );
  }

  final String accessToken;
  final String tokenType;

  AuthSession toEntity() =>
      AuthSession(accessToken: accessToken, tokenType: tokenType);
}
