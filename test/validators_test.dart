import 'package:flutter_test/flutter_test.dart';
import 'package:jo_modas/core/utils/validators.dart';

void main() {
  test('e-mail inválido é rejeitado', () {
    expect(Validators.email('abc'), isNotNull);
    expect(Validators.email('a@b.com'), isNull);
  });

  test('senha segue a regra do back-end (mínimo 6)', () {
    expect(Validators.password('12345'), isNotNull);
    expect(Validators.password('123456'), isNull);
  });

  test('CEP precisa de 8 dígitos e UF de 2 letras', () {
    expect(Validators.cep('85010-100'), isNull);
    expect(Validators.cep('123'), isNotNull);
    expect(Validators.uf('PR'), isNull);
    expect(Validators.uf('P'), isNotNull);
  });

  test('preço promocional precisa ser menor que o preço', () {
    expect(Validators.promotionalPrice('', '100'), isNull);
    expect(Validators.promotionalPrice('80,50', '100'), isNull);
    expect(Validators.promotionalPrice('100', '100'), isNotNull);
  });
}
