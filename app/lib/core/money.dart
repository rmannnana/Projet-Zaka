import 'package:intl/intl.dart';

/// Montant monétaire. Stocké en entier : le franc CFA (XOF) n'a pas de centimes.
/// Format Firestore : `{ amount: int, currency: "XOF" }`.
class Money implements Comparable<Money> {
  const Money(this.amount, {this.currency = defaultCurrency});

  static const defaultCurrency = 'XOF';
  static const zero = Money(0);

  final int amount;
  final String currency;

  factory Money.fromJson(Map<String, dynamic> json) => Money(
    (json['amount'] as num).toInt(),
    currency: json['currency'] as String? ?? defaultCurrency,
  );

  Map<String, dynamic> toJson() => {'amount': amount, 'currency': currency};

  Money operator +(Money other) {
    _checkSameCurrency(other);
    return Money(amount + other.amount, currency: currency);
  }

  Money operator -(Money other) {
    _checkSameCurrency(other);
    return Money(amount - other.amount, currency: currency);
  }

  Money operator *(int factor) => Money(amount * factor, currency: currency);

  /// Applique un pourcentage (ex. commission de 7,5 %), arrondi au franc près.
  Money percent(num rate) => Money((amount * rate / 100).round(), currency: currency);

  /// "125 000 FCFA"
  String format() {
    final digits = NumberFormat.decimalPattern('fr').format(amount);
    return '$digits ${currency == 'XOF' ? 'FCFA' : currency}';
  }

  void _checkSameCurrency(Money other) {
    if (other.currency != currency) {
      throw ArgumentError('Devises différentes : $currency / ${other.currency}');
    }
  }

  @override
  int compareTo(Money other) {
    _checkSameCurrency(other);
    return amount.compareTo(other.amount);
  }

  @override
  bool operator ==(Object other) =>
      other is Money && other.amount == amount && other.currency == currency;

  @override
  int get hashCode => Object.hash(amount, currency);

  @override
  String toString() => format();
}
