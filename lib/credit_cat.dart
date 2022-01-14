library credit_cat;

enum Issuers {
  VISA,
  MASTERCARD,
  DISCOVER,
  AMEX,
  UNKNOWN,
}

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

final List _ISSUER_IDENTIFIER_LIST = [
  {"RegExp": RegExp(r'^4'), "Issuers": Issuers.VISA},
  {"RegExp": RegExp(r'^5[1-5]'), "Issuers": Issuers.MASTERCARD},
  {"RegExp": RegExp(r'^6(0|4|5)(1|4)?(1)?'), "Issuers": Issuers.DISCOVER},
  {"RegExp": RegExp(r'^3(4|7)'), "Issuers": Issuers.AMEX}
];

class CreditCat {
  late String cardNumber;
  late Issuers cardIssuer;
  late Industries cardIndustry;
  late bool valid;

  CreditCat(String number) {
    this.cardNumber = number.replaceAll(RegExp(r"-|\s"), "");
    this._load();
  }

  CreditCat.clean(String number, RegExp patten) {
    this.cardNumber = number.replaceAll(patten, "");
    this._load();
  }

  bool _check(String number) {
    var reg = RegExp(r'^\d*$');
    return reg.hasMatch(number) && !number.isEmpty;
  }

  void _load() {
    if (_check(this.cardNumber)) {
      this.valid = this._validate(this.cardNumber);
      this.cardIndustry = this._industry(this.cardNumber);
      this.cardIssuer = this._issuer(this.cardNumber);
    } else {
      throw FormatException("Unclean Input: ${this.cardNumber}");
    }
  }

  int _calculate(String luhn) {
    var sum = luhn
        .split("")
        .map((e) => int.parse(e, radix: 10))
        .reduce((a, b) => a + b);

    final delta = [0, 1, 2, 3, 4, -4, -3, -2, -1, 0];
    for (var i = luhn.length - 1; i >= 0; i -= 2) {
      sum += delta[int.parse(luhn.substring(i, i + 1), radix: 10)];
    }

    final mod10 = 10 - (sum % 10);
    return mod10 == 10 ? 0 : mod10;
  }

  bool _validate(String luhn) {
    final luhnDigit =
        int.parse(luhn.substring(luhn.length - 1, luhn.length), radix: 10);
    final luhnLess = luhn.substring(0, luhn.length - 1);

    return (this._calculate(luhnLess) == luhnDigit);
  }

  Industries _industry(String number) {
    return _INDUSTRY_IDENTIFIER_MAP[number.substring(0, 1)] ??
        Industries.UNKNOWN;
  }

  Issuers _issuer(String number) {
    Issuers issuer = Issuers.UNKNOWN;

    final issuerID = number.substring(0, 6);
    _ISSUER_IDENTIFIER_LIST.forEach((item) {
      if (item["RegExp"].hasMatch(issuerID)) {
        issuer = item["Issuers"];
      }
    });

    return issuer;
  }
}
