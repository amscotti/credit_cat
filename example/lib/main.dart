import 'package:credit_cat/credit_cat.dart';

void main() {
  final cat = CreditCat("378282246310005");
  print(cat.isValid); // true
  print(cat.issuer); // Issuers.AMEX
  print(cat.industry); // Industries.TRAVEL_AND_ENTERTAINMENT

  print(cat.issuer == Issuers.AMEX); // true
  print(cat.industry == Industries.TRAVEL_AND_ENTERTAINMENT); // true

  final catClean = CreditCat("1*2*3*2*1*3*2*1*7", RegExp(r"\*"));
  print(catClean.number == "123213217"); // true
}
