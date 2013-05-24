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
    expect(cat1.cardIndustry, equals("Travel and Entertainment"));
    
    var cat2 = new creditCat("412321321");
    expect(cat2.cardIndustry, equals("Banking and Financial"));
    
    var cat3 = new creditCat("512321321");
    expect(cat3.cardIndustry, equals("Banking and Financial"));
  });
  
  test("Should return JSON object", () {
    var cat = new creditCat("5232132174");
    expect(cat.toJSON(), equals('{"number":"5232132174","industry":"Banking and Financial","valid":true}'));
  });
  
 }  
 