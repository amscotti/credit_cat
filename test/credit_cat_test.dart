library credit_cat_test;

import 'package:test/test.dart';

import 'package:credit_cat/credit_cat.dart';

main() {
  test("Should remove any dashs and space from the credit card number", () {
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

  test("Should throw error if patten removes all numbers from string", () {
    expect(
        () => CreditCat("123213217", RegExp(r"^\d*$")), throwsFormatException);
  });

  test("Should return true for a valid credit card number", () {
    final cat = CreditCat("123213217");
    expect(cat.isValid, equals(true));
  });

  test("Should return true for a valid credit card number", () {
    final cat = CreditCat("12321321");
    expect(cat.isValid, equals(false));
  });

  test("Should return the right industry name", () {
    final cat1 = CreditCat("312321321");
    expect(cat1.industry, equals(Industries.travelAndEntertainment));

    final cat2 = CreditCat("412321321");
    expect(cat2.industry, equals(Industries.bankingAndFinancial));

    final cat3 = CreditCat("512321321");
    expect(cat3.industry, equals(Industries.bankingAndFinancial));

    final cat4 = CreditCat("012321321");
    expect(cat4.industry, equals(Industries.unknown));
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
    var cat1 = CreditCat("510000");
    expect(cat1.issuer, equals(Issuers.mastercard));

    var cat2 = CreditCat("5555555555554444");
    expect(cat2.issuer, equals(Issuers.mastercard));

    var cat3 = CreditCat("5105105105105100");
    expect(cat3.issuer, equals(Issuers.mastercard));
  });

  test("Should return the right issuer name for Discover", () {
    var cat1 = CreditCat("601100");
    expect(cat1.issuer, equals(Issuers.discover));

    var cat2 = CreditCat("644000");
    expect(cat2.issuer, equals(Issuers.discover));

    var cat3 = CreditCat("650000");
    expect(cat3.issuer, equals(Issuers.discover));

    var cat4 = CreditCat("6011111111111117");
    expect(cat4.issuer, equals(Issuers.discover));

    var cat5 = CreditCat("6011000990139424");
    expect(cat5.issuer, equals(Issuers.discover));
  });

  test("Should return the right issuer for Amex", () {
    var cat1 = CreditCat("340000");
    expect(cat1.issuer, equals(Issuers.amex));

    var cat2 = CreditCat("370000");
    expect(cat2.issuer, equals(Issuers.amex));

    var cat3 = CreditCat("378282246310005");
    expect(cat3.issuer, equals(Issuers.amex));

    var cat4 = CreditCat("371449635398431");
    expect(cat4.issuer, equals(Issuers.amex));
  });

  test("Should return unknown for an issuer that hasn't been implemented yet",
      () {
    var cat1 = CreditCat("999999");
    expect(cat1.issuer, equals(Issuers.unknown));
  });
}
