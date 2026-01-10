import 'package:credit_cat/credit_cat.dart';

void main() {
  // Basic usage with Amex card
  final amex = CreditCat("378282246310005");
  print('=== Amex Card ===');
  print('Valid: ${amex.isValid}'); // true
  print('Issuer: ${amex.issuer}'); // Issuers.amex
  print('Industry: ${amex.industry}'); // Industries.travelAndEntertainment
  print('Masked: ${amex.maskedNumber}'); // ***********0005
  print('Formatted: ${amex.formattedNumber}'); // 3782 822463 10005

  // Visa card with dashes (auto-cleaned)
  print('\n=== Visa Card ===');
  final visa = CreditCat("4111-1111-1111-1111");
  print('Number: ${visa.number}'); // 4111111111111111
  print('Valid: ${visa.isValid}'); // true
  print('Formatted: ${visa.formattedNumber}'); // 4111 1111 1111 1111

  // Custom cleaning regex
  print('\n=== Custom Cleaning ===');
  final custom = CreditCat("4111.1111.1111.1111", RegExp(r"\."));
  print('Number: ${custom.number}'); // 4111111111111111

  // Invalid card (wrong length for Visa)
  print('\n=== Invalid Length ===');
  final invalid = CreditCat("41111111111111"); // 14 digits
  print('Valid: ${invalid.isValid}'); // false
  print('Valid Length: ${invalid.isValidLength}'); // false
}
