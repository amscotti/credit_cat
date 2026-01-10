## 2.0.0

### Breaking Changes
- `isValid` now checks both Luhn checksum AND card length for the issuer
- Renamed `Industries.merchandizingAndBanking` to `Industries.merchandisingAndBanking` (spelling fix)

### New Features
- Added issuers: Diners Club, JCB, UnionPay, Maestro
- Added `isLuhnValid` for Luhn-only validation
- Added `isValidLength` for length-only validation
- Added `maskedNumber` for display (e.g., "************1234")
- Added `formattedNumber` with proper spacing (4-6-5 for Amex, 4-4-4-4 for others)
- Added `toString()`, `==`, and `hashCode` implementations

### Improvements
- Updated to Dart 3 SDK
- Updated Mastercard BIN range to include 2221-2720 (2-series)
- Updated Discover BIN range to include 622126-622925
- Performance: length validation runs before Luhn algorithm
- Code modernization: factory constructor, final fields, static methods

## 1.0.0

- Add lints to project and fix issues found from `dart analyze`
- Upping version to `1.0.0` due to change to APIs with fixing of linting issues

## 0.4.1

- Fix spelling errors

## 0.4.0

- Rework internal logic and clean up APIs
- Documentation cleanup and adding examples

## 0.3.0

- Upgrading code to be usable in Dart 2.14.0 or greater