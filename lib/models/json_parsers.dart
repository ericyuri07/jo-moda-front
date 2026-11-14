/// O Laravel devolve `decimal:2` como texto ("300.00"); aceitamos texto ou
/// número.
double parseDouble(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? parseNullableDouble(Object? value) {
  if (value == null) return null;
  return parseDouble(value);
}
