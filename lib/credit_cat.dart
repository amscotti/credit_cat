/// A library for checking credit card numbers using the Luhn algorithm.
library;

/// enum used to hold credit card issuers.
enum Issuers {
  visa,
  mastercard,
  discover,
  amex,
  dinersClub,
  jcb,
  unionPay,
  maestro,
  unknown,
}

/// Valid card lengths for each issuer.
const Map<Issuers, List<int>> _validLengths = {
  Issuers.visa: [13, 16, 19],
  Issuers.mastercard: [16],
  Issuers.discover: [16, 19],
  Issuers.amex: [15],
  Issuers.dinersClub: [14, 16],
  Issuers.jcb: [16, 17, 18, 19],
  Issuers.unionPay: [16, 17, 18, 19],
  Issuers.maestro: [12, 13, 14, 15, 16, 17, 18, 19],
  Issuers.unknown: [],
};

/// enum used to hold credit card industries.
enum Industries {
  airlines,
  travelAndEntertainment,
  bankingAndFinancial,
  merchandisingAndBanking,
  petroleum,
  telecommunications,
  nationalAssignment,
  unknown
}

/// Map used to hold id to matching industries.
const Map<String, Industries> _industryIdentifier = {
  "1": Industries.airlines,
  "2": Industries.airlines,
  "3": Industries.travelAndEntertainment,
  "4": Industries.bankingAndFinancial,
  "5": Industries.bankingAndFinancial,
  "6": Industries.merchandisingAndBanking,
  "7": Industries.petroleum,
  "8": Industries.telecommunications,
  "9": Industries.nationalAssignment
};

class _IssuerIdentifier {
  final RegExp regexp;
  final Issuers issuer;

  const _IssuerIdentifier(this.regexp, this.issuer);

  bool hasMatch(String number) {
    final prefix = number.length >= 6 ? number.substring(0, 6) : number;
    return regexp.hasMatch(prefix);
  }
}

/// List of regular expressions to match card number to issuers.
/// Order matters - more specific patterns should come before broader ones.
final List<_IssuerIdentifier> _issuerIdentifier = [
  // Visa: starts with 4
  _IssuerIdentifier(RegExp(r'^4'), Issuers.visa),
  // Mastercard: 51-55, 2221-2720
  _IssuerIdentifier(
      RegExp(r'^(5[1-5]|2(22[1-9]|2[3-9]\d|[3-6]\d{2}|7[01]\d|720))'),
      Issuers.mastercard),
  // Discover: 6011, 622126-622925, 644-649, 65
  _IssuerIdentifier(
      RegExp(
          r'^(6011|622(1(2[6-9]|[3-9]\d)|[2-8]\d{2}|9([01]\d|2[0-5]))|64[4-9]|65)'),
      Issuers.discover),
  // UnionPay: 62 (excluding Discover's 622126-622925 range)
  _IssuerIdentifier(
      RegExp(r'^62(?!(2(1(2[6-9]|[3-9]\d)|[2-8]\d{2}|9([01]\d|2[0-5]))))'),
      Issuers.unionPay),
  // Amex: 34, 37
  _IssuerIdentifier(RegExp(r'^3[47]'), Issuers.amex),
  // Diners Club: 300-305, 36, 38
  _IssuerIdentifier(RegExp(r'^(30[0-5]|36|38)'), Issuers.dinersClub),
  // JCB: 3528-3589
  _IssuerIdentifier(RegExp(r'^35(2[89]|[3-8]\d)'), Issuers.jcb),
  // Maestro: 50, 56-69 (excluding ranges claimed by other issuers)
  _IssuerIdentifier(RegExp(r'^(50|5[6-9]|6[0-9])'), Issuers.maestro),
];

/// CreditCat class for validating and identifying credit card numbers.
class CreditCat {
  /// The cleaned card number
  final String number;

  /// The [Issuers] of the card
  final Issuers issuer;

  /// The [Industries] of the card
  final Industries industry;

  final bool _luhnValid;

  /// Creates a [CreditCat] object from a [number], with an optional [regex] for cleaning the number
  factory CreditCat(String number, [RegExp? regex]) {
    final cleanedNumber = number.replaceAll(regex ?? RegExp(r"-|\s"), "");

    if (cleanedNumber.isEmpty || !RegExp(r'^\d+$').hasMatch(cleanedNumber)) {
      throw FormatException("Invalid Input: $cleanedNumber");
    }

    final issuer = _issuer(cleanedNumber);

    // Check length first (cheap) before running Luhn (expensive)
    final lengths = _validLengths[issuer];
    final lengthValid = lengths == null ||
        lengths.isEmpty ||
        lengths.contains(cleanedNumber.length);
    final luhnValid = lengthValid ? _validateLuhn(cleanedNumber) : false;

    return CreditCat._internal(
      number: cleanedNumber,
      luhnValid: luhnValid,
      industry: _industry(cleanedNumber),
      issuer: issuer,
    );
  }

  CreditCat._internal({
    required this.number,
    required bool luhnValid,
    required this.industry,
    required this.issuer,
  }) : _luhnValid = luhnValid;

  /// Whether the card number passes Luhn checksum validation.
  bool get isLuhnValid => _luhnValid;

  /// Whether the card number length is valid for the detected issuer.
  bool get isValidLength {
    final lengths = _validLengths[issuer];
    if (lengths == null || lengths.isEmpty) return true;
    return lengths.contains(number.length);
  }

  /// Whether the card is valid (passes Luhn checksum and has correct length for issuer).
  bool get isValid => _luhnValid && isValidLength;

  /// Returns the card number with all but the last 4 digits masked.
  /// Example: "************1234"
  String get maskedNumber {
    if (number.length <= 4) return number;
    return '${'*' * (number.length - 4)}${number.substring(number.length - 4)}';
  }

  /// Returns the card number formatted with spaces.
  /// Amex uses 4-6-5 grouping, others use 4-4-4-4 grouping.
  String get formattedNumber {
    if (issuer == Issuers.amex && number.length == 15) {
      // Amex: 4-6-5 grouping
      return '${number.substring(0, 4)} ${number.substring(4, 10)} ${number.substring(10)}';
    }
    // Standard 4-digit grouping
    final buffer = StringBuffer();
    for (var i = 0; i < number.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(number[i]);
    }
    return buffer.toString();
  }

  @override
  String toString() =>
      'CreditCat(number: $maskedNumber, issuer: $issuer, isValid: $isValid)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreditCat &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;

  // Validates the credit card number using Luhn algorithm
  static bool _validateLuhn(String number) {
    final sum = number.split('').reversed.toList().asMap().entries.fold(0,
        (total, entry) {
      final digit = int.parse(entry.value);
      final value = entry.key.isOdd ? digit * 2 : digit;
      return total + (value > 9 ? value - 9 : value);
    });
    return sum % 10 == 0;
  }

  static Industries _industry(String number) {
    return _industryIdentifier[number.substring(0, 1)] ?? Industries.unknown;
  }

  static Issuers _issuer(String number) {
    for (final identifier in _issuerIdentifier) {
      if (identifier.hasMatch(number)) {
        return identifier.issuer;
      }
    }
    return Issuers.unknown;
  }
}
