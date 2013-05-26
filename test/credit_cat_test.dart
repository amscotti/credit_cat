 library credit_cat_test;  
   
 import 'package:credit_cat/credit_cat.dart';  
 import 'package:unittest/unittest.dart';
  
 main() {
  test("Should remove any dashs and space from the credit card number", () {
    var cat = new creditCat("1-2-3-2-1 3-2-1-7");
    expect(cat.cardNumber, equals("123213217"));  
  });
  
  test("Should remove anything based on the RegExp from the credit card number", () {
    var cat = new creditCat.clean("1*2*3*2*1*3*2*1*7", new RegExp(r"\*"));
    expect(cat.cardNumber, equals("123213217"));  
  });
  
  test("Should throw error when string is not a number", () {
    expect(() => new creditCat("Not a Number"),throwsFormatException);  
  });
  
  test("Should throw error when string is empty", () {
    expect(() => new creditCat(""),throwsFormatException);  
  });
  
  test("Should return true for a valid credit card number", () {
    var cat = new creditCat("123213217");
    expect(cat.valid, equals(true));  
  });
  
  test("Should return true for a valid credit card number", () {
    var cat = new creditCat("12321321");
    expect(cat.valid, equals(false));  
  });
  
  test("Should return the right industry name", () {
    var cat1 = new creditCat("312321321");
    expect(cat1.cardIndustry, equals(Industries.TRAVEL_AND_ENTERTAINMENT));
    
    var cat2 = new creditCat("412321321");
    expect(cat2.cardIndustry, equals(Industries.BANKING_AND_FINANCIAL));
    
    var cat3 = new creditCat("512321321");
    expect(cat3.cardIndustry, equals(Industries.BANKING_AND_FINANCIAL));
  });
    
  test("Should return the right issuer name for Visa", () {
    var cat = new creditCat("400000");
    expect(cat.cardIssuer, equals("Visa"));  
  });
  
  test("Should return the right issuer name for Mastercard", () {
    var cat = new creditCat("510000");
    expect(cat.cardIssuer, equals("Mastercard")); 
  });
  
  test("Should return the right issuer name for Discover", () {
    var cat1 = new creditCat("601100");
    expect(cat1.cardIssuer, equals("Discover"));
    
    var cat2 = new creditCat("644000");
    expect(cat2.cardIssuer, equals("Discover"));
    
    var cat3 = new creditCat("650000");
    expect(cat3.cardIssuer, equals("Discover"));
  });
  
  test("Should return the right issuer for Amex", () {
    var cat1 = new creditCat("340000");
    expect(cat1.cardIssuer, equals("Amex"));
    
    var cat2 = new creditCat("370000");
    expect(cat2.cardIssuer, equals("Amex"));
  });
  
  test("Should return unknown for an issuer that hasn't been implemented yet", () {
    var cat1 = new creditCat("999999");
    expect(cat1.cardIssuer, equals("Unknown"));
  });
  
  test("Should return JSON object", () {
    var cat = new creditCat("5232132174");
    expect(cat.toJSON(), equals('{"number":"5232132174","industry":"Banking and Financial","issuer":"Mastercard","valid":true}'));
  });
  
 }  
 