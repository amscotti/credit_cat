/// A library for checking credit card numbers using the Luhn algorithm.
library credit_cat;

/// enum used to hold credit card issuers.
enum Issuers {
  visa,
  mastercard,
  discover,
  amex,
  unknown,
}

/// enum used to hold credit card industries.
enum Industries {
  airlines,
  travelAndEntertainment,
  bankingAndFinancial,
  merchandizingAndBanking,
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
  "6": Industries.merchandizingAndBanking,
  "7": Industries.petroleum,
  "8": Industries.telecommunications,
  "9": Industries.nationalAssignment
};

class _IssuerIdentifier {
  RegExp regexp;
  Issuers issuers;

  _IssuerIdentifier(this.regexp, this.issuers);

  bool hasMatch(String number) {
    return regexp.hasMatch(number.substring(0, 6));
  }
}

/// List of regular expressions to match card number to issuers
final List<_IssuerIdentifier> _issuerIdentifier = [
  _IssuerIdentifier(RegExp(r'^4'), Issuers.visa),
  _IssuerIdentifier(RegExp(r'^5[1-5]'), Issuers.mastercard),
  _IssuerIdentifier(RegExp(r'^6(0|4|5)(1|4)?(1)?'), Issuers.discover),
  _IssuerIdentifier(RegExp(r'^3(4|7)'), Issuers.amex),
];

/// CreditCat class
class CreditCat {
  late String _number;
  late Issuers _cardIssuer;
  late Industries _cardIndustry;
  late bool _valid;

  /// Returns the card number
  String get number => _number;

  /// Returns the [Issuers] of the card
  Issuers get issuer => _cardIssuer;

  /// Returns the [Industries] of the card
  Industries get industry => _cardIndustry;

  /// Returns a [bool] based on if the card has a valid number
  bool get isValid => _valid;

  /// Creates a [CreditCat] object from a [number], with an optional [regex] for cleaning the number
  CreditCat(String number, [RegExp? regex]) {
    _number = number.replaceAll(regex ?? RegExp(r"-|\s"), "");

    if (_number.isNotEmpty && RegExp(r'^\d*$').hasMatch(_number)) {
      _valid = _validate();
      _cardIndustry = _industry();
      _cardIssuer = _issuer();
    } else {
      throw FormatException("Invalid Input: $_number");
    }
  }

  // Used to validate the credit card number
  bool _validate() {
    int doubleEverySecond = 0;

    _number
        .split('')
        .reversed
        .map(int.parse)
        .toList()
        .asMap()
        .forEach((index, number) {
      int b = index.isOdd ? number * 2 : number;
      doubleEverySecond += b > 9 ? b - 9 : b;
    });

    return doubleEverySecond % 10 == 0;
  }

  Industries _industry() {
    return _industryIdentifier[_number.substring(0, 1)] ?? Industries.unknown;
  }

  Issuers _issuer() {
    final issuer = _issuerIdentifier.firstWhere(
        (element) => element.hasMatch(_number),
        orElse: () => _IssuerIdentifier(RegExp(r''), Issuers.unknown));

    return issuer.issuers;
  }
}
