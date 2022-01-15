/// A library for checking credit card numbers using the Luhn algorithm.
library credit_cat;

/// enum used to hold credit card issuers.
enum Issuers {
  VISA,
  MASTERCARD,
  DISCOVER,
  AMEX,
  UNKNOWN,
}

/// enum used to hold credit card industries.
enum Industries {
  AIRLINES,
  TRAVEL_AND_ENTERTAINMENT,
  BANKING_AND_FINANCIAL,
  MERCHANDIZING_AND_BANKING,
  PETROLEUM,
  TELECOMMUNICATIONS,
  NATIONAL_ASSIGNMENT,
  UNKNOWN
}

/// Map used to hold id to matching industries.
const Map<String, Industries> _INDUSTRY_IDENTIFIER_MAP = {
  "1": Industries.AIRLINES,
  "2": Industries.AIRLINES,
  "3": Industries.TRAVEL_AND_ENTERTAINMENT,
  "4": Industries.BANKING_AND_FINANCIAL,
  "5": Industries.BANKING_AND_FINANCIAL,
  "6": Industries.MERCHANDIZING_AND_BANKING,
  "7": Industries.PETROLEUM,
  "8": Industries.TELECOMMUNICATIONS,
  "9": Industries.NATIONAL_ASSIGNMENT
};

class _IssuerIdentifier {
  RegExp regexp;
  Issuers issuers;

  _IssuerIdentifier(this.regexp, this.issuers) {}

  bool hasMatch(String number) {
    return regexp.hasMatch(number.substring(0, 6));
  }
}

/// List of regular expressions to match card number to issuers
final List<_IssuerIdentifier> _ISSUER_IDENTIFIER_LIST = [
  _IssuerIdentifier(RegExp(r'^4'), Issuers.VISA),
  _IssuerIdentifier(RegExp(r'^5[1-5]'), Issuers.MASTERCARD),
  _IssuerIdentifier(RegExp(r'^6(0|4|5)(1|4)?(1)?'), Issuers.DISCOVER),
  _IssuerIdentifier(RegExp(r'^3(4|7)'), Issuers.AMEX),
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

  /// Creates a [CreditCat] object from a [number], with an optional pattern for cleaning the number
  CreditCat(String number, [RegExp? patten]) {
    _number = number.replaceAll(patten ?? RegExp(r"-|\s"), "");

    if (!_number.isEmpty && RegExp(r'^\d*$').hasMatch(_number)) {
      _valid = _validate();
      _cardIndustry = _industry();
      _cardIssuer = _issuer();
    } else {
      throw FormatException("Invalid Input: ${_number}");
    }
  }

  // Used to validate the credit card number
  bool _validate() {
    int doubleEverySecond = 0;

    this
        ._number
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
    return _INDUSTRY_IDENTIFIER_MAP[_number.substring(0, 1)] ??
        Industries.UNKNOWN;
  }

  Issuers _issuer() {
    final issuer = _ISSUER_IDENTIFIER_LIST.firstWhere(
        (element) => element.hasMatch(_number),
        orElse: () => _IssuerIdentifier(RegExp(r''), Issuers.UNKNOWN));

    return issuer.issuers;
  }
}
