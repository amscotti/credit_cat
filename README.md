# credit_cat

credit_cat is a library for checking credit card numbers using the Luhn algorithm. Besides identifying if the number is valid or not, It will also let you know who is the issuer of the card is and industry it falls under.
## Overview

```dart
import 'package:credit_cat/credit_cat.dart';

void main() {
  final cat = CreditCat("378282246310005");
  print(cat.isValid); // true
  print(cat.issuer); // Issuers.AMEX
  print(cat.industry); // Industries.TRAVEL_AND_ENTERTAINMENT

  print(cat.issuer == Issuers.AMEX); // true
  print(cat.industry == Industries.TRAVEL_AND_ENTERTAINMENT); // true
}
```

### Dirty Number

credit_cat will automatically remove any space or dashes from the string passed to it but you are also able to pass your own regular expression into CreditCat,

```dart
final catClean = CreditCat("1*2*3*2*1*3*2*1*7", RegExp(r"\*"));
print(catClean.number == "123213217"); // true
```