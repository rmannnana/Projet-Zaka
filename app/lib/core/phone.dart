/// Pays de la zone UEMOA, Burkina Faso en tête.
///
/// Les SMS de vérification sont limités à ces indicatifs (coûts, fraude).
class UemoaCountry {
  const UemoaCountry(this.code, this.name, this.dialCode, this.nationalLengths);

  /// Code ISO 3166-1 alpha-2.
  final String code;
  final String name;
  final String dialCode;

  /// Nombres de chiffres acceptés après l'indicatif.
  final List<int> nationalLengths;

  String get flag => String.fromCharCodes(code.codeUnits.map((c) => 0x1F1E6 + c - 0x41));
}

const uemoaCountries = [
  UemoaCountry('BF', 'Burkina Faso', '226', [8]),
  UemoaCountry('BJ', 'Bénin', '229', [8, 10]),
  UemoaCountry('CI', "Côte d'Ivoire", '225', [10]),
  UemoaCountry('GW', 'Guinée-Bissau', '245', [9]),
  UemoaCountry('ML', 'Mali', '223', [8]),
  UemoaCountry('NE', 'Niger', '227', [8]),
  UemoaCountry('SN', 'Sénégal', '221', [9]),
  UemoaCountry('TG', 'Togo', '228', [8]),
];

UemoaCountry countryByCode(String? code) =>
    uemoaCountries.firstWhere((c) => c.code == code, orElse: () => uemoaCountries.first);

/// Convertit une saisie libre (« 70 12 34 56 », « +226 70123456 »,
/// « 0022670123456 ») au format international E.164, ou renvoie null si le
/// numéro ne correspond pas au pays choisi.
String? toE164(UemoaCountry country, String input) {
  var digits = input.replaceAll(RegExp(r'\D'), '');
  for (final prefix in ['00${country.dialCode}', country.dialCode]) {
    if (digits.startsWith(prefix) &&
        country.nationalLengths.contains(digits.length - prefix.length)) {
      digits = digits.substring(prefix.length);
      break;
    }
  }
  if (!country.nationalLengths.contains(digits.length)) return null;
  return '+${country.dialCode}$digits';
}
