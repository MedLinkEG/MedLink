import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/features/auth/data/models/auth_response_model.dart';

void main() {
  test('reads the token from the backend response', () {
    final model = AuthResponseModel.fromJson({
      'accessToken': 'abc.def.ghi',
      'tokenType': 'Bearer',
    });

    expect(model.accessToken, 'abc.def.ghi');
    expect(model.tokenType, 'Bearer');
  });

  test('uses Bearer when the backend sends no token type', () {
    final model = AuthResponseModel.fromJson({'accessToken': 'abc.def.ghi'});

    expect(model.tokenType, 'Bearer');
  });

  test('turns into an AuthSession entity', () {
    const model = AuthResponseModel(accessToken: 'abc', tokenType: 'Bearer');

    final session = model.toEntity();

    expect(session.accessToken, 'abc');
    expect(session.tokenType, 'Bearer');
  });
}
