import 'package:test/test.dart';

import 'package:credit_cat/credit_cat.dart';

void main() {
  test("Should remove any dashes and spaces from the credit card number", () {
    final cat = CreditCat("1-2-3-2-1 3-2-1-7");
    expect(cat.number, equals("123213217"));
  });

  test("Should remove anything based on the RegExp from the credit card number",
      () {
    final cat = CreditCat("1*2*3*2*1*3*2*1*7", RegExp(r"\*"));
    expect(cat.number, equals("123213217"));
  });

  test("Should throw error when string is not a number", () {
    expect(() => CreditCat("Not a Number"), throwsFormatException);
  });

  test("Should throw error when string is empty", () {
    expect(() => CreditCat(""), throwsFormatException);
  });

  test("Should throw error if pattern removes all numbers from string", () {
    expect(
        () => CreditCat("123213217", RegExp(r"^\d*$")), throwsFormatException);
  });

  test("Should return true for a valid credit card number", () {
    final cat = CreditCat("123213217");
    expect(cat.isValid, equals(true));
  });

  test("Should return false for an invalid credit card number", () {
    final cat = CreditCat("12321321");
    expect(cat.isValid, equals(false));
  });

  test("Should return the right industry name", () {
    // Airlines (1, 2)
    final cat1 = CreditCat("112321321");
    expect(cat1.industry, equals(Industries.airlines));

    final cat2 = CreditCat("212321321");
    expect(cat2.industry, equals(Industries.airlines));

    // Travel and Entertainment (3)
    final cat3 = CreditCat("312321321");
    expect(cat3.industry, equals(Industries.travelAndEntertainment));

    // Banking and Financial (4, 5)
    final cat4 = CreditCat("412321321");
    expect(cat4.industry, equals(Industries.bankingAndFinancial));

    final cat5 = CreditCat("512321321");
    expect(cat5.industry, equals(Industries.bankingAndFinancial));

    // Merchandising and Banking (6)
    final cat6 = CreditCat("612321321");
    expect(cat6.industry, equals(Industries.merchandisingAndBanking));

    // Petroleum (7)
    final cat7 = CreditCat("712321321");
    expect(cat7.industry, equals(Industries.petroleum));

    // Telecommunications (8)
    final cat8 = CreditCat("812321321");
    expect(cat8.industry, equals(Industries.telecommunications));

    // National Assignment (9)
    final cat9 = CreditCat("912321321");
    expect(cat9.industry, equals(Industries.nationalAssignment));

    // Unknown (0)
    final cat0 = CreditCat("012321321");
    expect(cat0.industry, equals(Industries.unknown));
  });

  test("Should return the right issuer name for Visa", () {
    final cat1 = CreditCat("400000");
    expect(cat1.issuer, equals(Issuers.visa));

    final cat2 = CreditCat("4111111111111111");
    expect(cat2.issuer, equals(Issuers.visa));

    final cat3 = CreditCat("4012888888881881");
    expect(cat3.issuer, equals(Issuers.visa));

    final cat4 = CreditCat("4222222222222");
    expect(cat4.issuer, equals(Issuers.visa));
  });

  test("Should return the right issuer name for Mastercard", () {
    // Traditional 51-55 range
    final cat1 = CreditCat("510000");
    expect(cat1.issuer, equals(Issuers.mastercard));

    final cat2 = CreditCat("5555555555554444");
    expect(cat2.issuer, equals(Issuers.mastercard));

    final cat3 = CreditCat("5105105105105100");
    expect(cat3.issuer, equals(Issuers.mastercard));

    // New 2-series range (2221-2720)
    final cat4 = CreditCat("2221000000000000");
    expect(cat4.issuer, equals(Issuers.mastercard));

    final cat5 = CreditCat("2720000000000000");
    expect(cat5.issuer, equals(Issuers.mastercard));

    final cat6 = CreditCat("2500000000000000");
    expect(cat6.issuer, equals(Issuers.mastercard));
  });

  test("Should return unknown for numbers outside Mastercard 2-series range",
      () {
    // 2220 is below the 2221-2720 range
    final cat1 = CreditCat("2220000000000000");
    expect(cat1.issuer, equals(Issuers.unknown));

    // 2721 is above the 2221-2720 range
    final cat2 = CreditCat("2721000000000000");
    expect(cat2.issuer, equals(Issuers.unknown));
  });

  test("Should return the right issuer name for Discover", () {
    // 6011 range
    final cat1 = CreditCat("601100");
    expect(cat1.issuer, equals(Issuers.discover));

    final cat2 = CreditCat("6011111111111117");
    expect(cat2.issuer, equals(Issuers.discover));

    final cat3 = CreditCat("6011000990139424");
    expect(cat3.issuer, equals(Issuers.discover));

    // 644-649 range
    final cat4 = CreditCat("644000");
    expect(cat4.issuer, equals(Issuers.discover));

    final cat5 = CreditCat("649000");
    expect(cat5.issuer, equals(Issuers.discover));

    // 65 range
    final cat6 = CreditCat("650000");
    expect(cat6.issuer, equals(Issuers.discover));

    // 622126-622925 range (UnionPay co-branded)
    final cat7 = CreditCat("6221260000000000");
    expect(cat7.issuer, equals(Issuers.discover));

    final cat8 = CreditCat("6229250000000000");
    expect(cat8.issuer, equals(Issuers.discover));

    final cat9 = CreditCat("6225000000000000");
    expect(cat9.issuer, equals(Issuers.discover));
  });

  test(
      "Should return UnionPay for 62 numbers outside Discover 622126-622925 range",
      () {
    // 622125 is below the Discover range, so it's UnionPay
    final cat1 = CreditCat("6221250000000000");
    expect(cat1.issuer, equals(Issuers.unionPay));

    // 622926 is above the Discover range, so it's UnionPay
    final cat2 = CreditCat("6229260000000000");
    expect(cat2.issuer, equals(Issuers.unionPay));
  });

  test("Should return the right issuer name for Diners Club", () {
    // 300-305 range
    final cat1 = CreditCat("30000000000000");
    expect(cat1.issuer, equals(Issuers.dinersClub));

    final cat2 = CreditCat("30500000000000");
    expect(cat2.issuer, equals(Issuers.dinersClub));

    // 36 range
    final cat3 = CreditCat("36000000000000");
    expect(cat3.issuer, equals(Issuers.dinersClub));

    // 38 range
    final cat4 = CreditCat("38000000000000");
    expect(cat4.issuer, equals(Issuers.dinersClub));
  });

  test("Should return unknown for numbers outside Diners Club range", () {
    // 306 is outside 300-305
    final cat1 = CreditCat("30600000000000");
    expect(cat1.issuer, equals(Issuers.unknown));

    // 39 is not a Diners Club prefix
    final cat2 = CreditCat("39000000000000");
    expect(cat2.issuer, equals(Issuers.unknown));
  });

  test("Should return the right issuer name for JCB", () {
    // 3528-3589 range
    final cat1 = CreditCat("3528000000000000");
    expect(cat1.issuer, equals(Issuers.jcb));

    final cat2 = CreditCat("3589000000000000");
    expect(cat2.issuer, equals(Issuers.jcb));

    final cat3 = CreditCat("3550000000000000");
    expect(cat3.issuer, equals(Issuers.jcb));
  });

  test("Should return unknown for numbers outside JCB range", () {
    // 3527 is below the range
    final cat1 = CreditCat("3527000000000000");
    expect(cat1.issuer, equals(Issuers.unknown));

    // 3590 is above the range
    final cat2 = CreditCat("3590000000000000");
    expect(cat2.issuer, equals(Issuers.unknown));
  });

  test("Should return the right issuer for Amex", () {
    final cat1 = CreditCat("340000");
    expect(cat1.issuer, equals(Issuers.amex));

    final cat2 = CreditCat("370000");
    expect(cat2.issuer, equals(Issuers.amex));

    final cat3 = CreditCat("378282246310005");
    expect(cat3.issuer, equals(Issuers.amex));

    final cat4 = CreditCat("371449635398431");
    expect(cat4.issuer, equals(Issuers.amex));
  });

  test("Should return unknown for an issuer that hasn't been implemented yet",
      () {
    final cat1 = CreditCat("999999");
    expect(cat1.issuer, equals(Issuers.unknown));
  });

  test("Should detect issuer for short card numbers (less than 6 digits)", () {
    final cat1 = CreditCat("4111");
    expect(cat1.issuer, equals(Issuers.visa));

    final cat2 = CreditCat("51");
    expect(cat2.issuer, equals(Issuers.mastercard));

    final cat3 = CreditCat("34");
    expect(cat3.issuer, equals(Issuers.amex));
  });

  test("Should return Maestro for numbers in 50, 56-69 range", () {
    final cat1 = CreditCat("500000");
    expect(cat1.issuer, equals(Issuers.maestro));

    final cat2 = CreditCat("560000");
    expect(cat2.issuer, equals(Issuers.maestro));

    final cat3 = CreditCat("6900000000000000");
    expect(cat3.issuer, equals(Issuers.maestro));
  });

  test("Should throw error when input becomes empty after cleaning", () {
    expect(() => CreditCat("---"), throwsFormatException);
    expect(() => CreditCat("   "), throwsFormatException);
    expect(() => CreditCat("- - -"), throwsFormatException);
  });

  test("Should validate single digit numbers", () {
    final cat0 = CreditCat("0");
    expect(cat0.isValid, equals(true));

    final cat5 = CreditCat("5");
    expect(cat5.isValid, equals(false));
  });

  test("Should return the right issuer name for UnionPay", () {
    // 62 range (excluding Discover's 622126-622925)
    final cat1 = CreditCat("6200000000000000");
    expect(cat1.issuer, equals(Issuers.unionPay));

    final cat2 = CreditCat("6210000000000000");
    expect(cat2.issuer, equals(Issuers.unionPay));

    // 622125 and below should be UnionPay (not in Discover range)
    final cat3 = CreditCat("6221250000000000");
    expect(cat3.issuer, equals(Issuers.unionPay));

    // 622926 and above should be UnionPay (not in Discover range)
    final cat4 = CreditCat("6229260000000000");
    expect(cat4.issuer, equals(Issuers.unionPay));
  });

  test("Should validate card length for different issuers", () {
    // Visa: valid lengths are 13, 16, 19
    final visa13 = CreditCat("4111111111111");
    expect(visa13.isValidLength, equals(true));

    final visa16 = CreditCat("4111111111111111");
    expect(visa16.isValidLength, equals(true));

    final visa15 = CreditCat("411111111111111");
    expect(visa15.isValidLength, equals(false));

    // Amex: valid length is 15
    final amex15 = CreditCat("378282246310005");
    expect(amex15.isValidLength, equals(true));

    final amex16 = CreditCat("3782822463100050");
    expect(amex16.isValidLength, equals(false));

    // Mastercard: valid length is 16
    final mc16 = CreditCat("5555555555554444");
    expect(mc16.isValidLength, equals(true));

    final mc15 = CreditCat("555555555555444");
    expect(mc15.isValidLength, equals(false));
  });

  test("Should return isValid only when both Luhn and length are valid", () {
    // Valid Luhn + valid length -> isValid true
    final validCard = CreditCat("4111111111111111");
    expect(validCard.isLuhnValid, equals(true));
    expect(validCard.isValidLength, equals(true));
    expect(validCard.isValid, equals(true));

    // Invalid length (15 digit Visa) -> isValid false, Luhn not computed
    final wrongLength = CreditCat("411111111111116");
    expect(wrongLength.isValidLength, equals(false));
    expect(wrongLength.isValid, equals(false));

    // Invalid Luhn + valid length -> isValid false
    final invalidLuhn = CreditCat("4111111111111112");
    expect(invalidLuhn.isLuhnValid, equals(false));
    expect(invalidLuhn.isValidLength, equals(true));
    expect(invalidLuhn.isValid, equals(false));
  });

  test("Should return masked number with last 4 digits visible", () {
    final cat1 = CreditCat("4111111111111111");
    expect(cat1.maskedNumber, equals("************1111"));

    final cat2 = CreditCat("378282246310005");
    expect(cat2.maskedNumber, equals("***********0005"));

    // Short numbers (4 or fewer digits) return as-is
    final cat3 = CreditCat("1234");
    expect(cat3.maskedNumber, equals("1234"));

    final cat4 = CreditCat("123");
    expect(cat4.maskedNumber, equals("123"));
  });

  test("Should return formatted number with proper spacing", () {
    // Standard 4-4-4-4 grouping for Visa
    final visa = CreditCat("4111111111111111");
    expect(visa.formattedNumber, equals("4111 1111 1111 1111"));

    // Standard 4-4-4-4 grouping for Mastercard
    final mc = CreditCat("5555555555554444");
    expect(mc.formattedNumber, equals("5555 5555 5555 4444"));

    // Amex uses 4-6-5 grouping
    final amex = CreditCat("378282246310005");
    expect(amex.formattedNumber, equals("3782 822463 10005"));

    // 13-digit Visa
    final visa13 = CreditCat("4111111111111");
    expect(visa13.formattedNumber, equals("4111 1111 1111 1"));
  });

  test("Should return correct string representation", () {
    final cat = CreditCat("4111111111111111");
    expect(
        cat.toString(),
        equals(
            "CreditCat(number: ************1111, issuer: Issuers.visa, isValid: true)"));
  });

  test("Should support equality comparison", () {
    final cat1 = CreditCat("4111111111111111");
    final cat2 = CreditCat("4111-1111-1111-1111");
    final cat3 = CreditCat("5555555555554444");

    expect(cat1 == cat2, equals(true));
    expect(cat1 == cat3, equals(false));
    expect(cat1.hashCode == cat2.hashCode, equals(true));
  });
}
