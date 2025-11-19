enum FaixaEtaria {
  livre('Livre'),
  dez('10'),
  doze('12'),
  quatorze('14'),
  dezesseis('16'),
  dezoito('18');

  final String displayValue;
  const FaixaEtaria(this.displayValue);

  static List<String> get valuesAsList =>
      FaixaEtaria.values.map((e) => e.displayValue).toList();
}
