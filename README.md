# credit_cat

credit_cat is a library for checking credit card numbers using the Luhn algorithm. Besides identifying if the number is valid or not, It will also let you know who is the issuer of the card is and industry it falls under.

## Installing

Add this to your package's pubspec.yaml file:
```
dependencies:
  credit_cat: any
```

If you're using the Dart Editor, choose:

```
Menu > Tools > Pub Install
```

Or if you want to install from the command line, run:

```
$ dart pub install
```

Now in your Dart code, you can use:

```dart
import 'package:credit_cat/credit_cat.dart';
```

## Overview

```dart
var cat = new CreditCat("378282246310005");
print(cat.valid); // true
print(cat.cardIssuer); // Amex
print(cat.cardIndustry); // Travel and Entertainment

print(cat.cardIssuer == Issuers.AMEX); // true
print(cat.cardIndustry == Industries.TRAVEL_AND_ENTERTAINMENT); // true
```

### Dirty Number

credit_Cat will automatically remove any space or dashes from the string passed to it but you are also able to pass your own regular expression into creditCat.clean,

```dart
var cat = new CreditCat.clean("1*2*3*2*1*3*2*1*7", new RegExp(r"\*"));
print(cat.cardNumber == "123213217"); // true  
```