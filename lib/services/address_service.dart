import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_config.dart';
import '../core/constants/app_strings.dart';
import '../models/cep_address.dart';
import 'api_exception.dart';

/// Consulta de CEP na API pública ViaCEP: `GET /ws/{cep}/json/`.
class AddressService {
  AddressService({http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final http.Client _http;

  /// Devolve o endereço do CEP (só dígitos) ou lança [ApiException].
  Future<CepAddress> lookup(String cepDigits) async {
    final Uri uri = Uri.parse('${AppConfig.viaCepBaseUrl}/$cepDigits/json/');

    try {
      final http.Response response = await _http
          .get(uri)
          .timeout(AppConfig.requestTimeout);

      if (response.statusCode != 200) {
        throw ApiException(AppStrings.cepNotFound);
      }

      final Map<String, dynamic> json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      if (json['erro'] != null) throw ApiException(AppStrings.cepNotFound);

      return CepAddress.fromJson(json);
    } on TimeoutException {
      throw ApiException(AppStrings.cepNotFound);
    } on http.ClientException {
      throw ApiException(AppStrings.cepNotFound);
    } on FormatException {
      throw ApiException(AppStrings.cepNotFound);
    }
  }
}
