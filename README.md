# credit_cat

credit_cat is a Dart library for validating and identifying credit card numbers. It validates using the Luhn algorithm and length checking, identifies the card issuer, and determines the industry category.

## Supported Issuers

Visa, Mastercard, American Express, Discover, Diners Club, JCB, UnionPay, Maestro

## Overview

```dart
import 'package:credit_cat/credit_cat.dart';

void main() {
  final cat = CreditCat("378282246310005");

  // Validation (Luhn + length check)
  print(cat.isValid); // true

  // Card identification
  print(cat.issuer); // Issuers.amex
  print(cat.industry); // Industries.travelAndEntertainment

  // Display helpers
  print(cat.maskedNumber); // ***********0005
  print(cat.formattedNumber); // 3782 822463 10005
}
```

## Features

### Validation

`isValid` checks both the Luhn checksum and that the card length is correct for the detected issuer.

```dart
final valid = CreditCat("4111111111111111");
print(valid.isValid); // true (valid Luhn + 16 digits for Visa)

final invalidLength = CreditCat("41111111111111"); // 14 digits
print(invalidLength.isValid); // false (Visa requires 13, 16, or 19 digits)
```

You can also check components separately:
- `isLuhnValid` - Luhn checksum only
- `isValidLength` - length validation only

### Input Cleaning

credit_cat automatically removes spaces and dashes from the input:

```dart
final cat = CreditCat("4111-1111-1111-1111");
print(cat.number); // 4111111111111111
```

You can also provide a custom regex for cleaning:

```dart
final cat = CreditCat("4111.1111.1111.1111", RegExp(r"\."));
print(cat.number); // 4111111111111111
```

### Display Helpers

```dart
final cat = CreditCat("4111111111111111");

// Masked for receipts/display
print(cat.maskedNumber); // ************1111

// Formatted with spaces (Amex uses 4-6-5, others use 4-4-4-4)
print(cat.formattedNumber); // 4111 1111 1111 1111
```
