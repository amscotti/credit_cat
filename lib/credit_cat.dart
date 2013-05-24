library credit_cat;

import 'dart:json';

class creditCat {
  String cardNumber;
  String cardIssuer;
  String cardIndustry;
  bool valid;
  
  var _INDUSTRY_IDENTIFIER_MAP = {"1": "Airlines", "2": "Airlines", "3": "Travel and Entertainment",
                                  "4": "Banking and Financial", "5": "Banking and Financial", "6": "Merchandizing and Banking",
                                  "7": "Petroleum", "8": "Telecommunications", "9": "National Assignment"};
  
  creditCat(String number){
    this.cardNumber = number.replaceAll(new RegExp(r"-|\s"), "");
    this._load();
  }
  
  creditCat.clean(String number, RegExp patten){
    this.cardNumber = number.replaceAll(patten, "");
    this._load();
  }
  
  bool _check(String number){
    var reg = new RegExp(r'^\d*$');
    return reg.hasMatch(number) && !number.isEmpty;
  }
  
  _load(){
    if(_check(this.cardNumber)){
      this.valid = this._validate(this.cardNumber);
      this.cardIndustry = this._industry(this.cardNumber); 
    } else {
      throw new FormatException("Unclean Input: ${this.cardNumber}");
    }
  }
  
  int _calculate(luhn) {
    var sum = luhn.split("").map((e) => int.parse(e, radix:10)).reduce((a,b) => a + b);
 
    var delta = [0,1,2,3,4,-4,-3,-2,-1,0];    
    for (var i=luhn.length-1; i >= 0; i-=2 ) {   
      sum += delta[int.parse(luhn.substring(i,i+1), radix:10)];
    } 
    var mod10 = 10 - (sum % 10);
    if (mod10==10) {
      mod10=0;
    }
    return mod10;
  }
  
  bool _validate(luhn) {
    var luhnDigit = int.parse(luhn.substring(luhn.length-1,luhn.length), radix:10);
    var luhnLess = luhn.substring(0,luhn.length-1);
    return (this._calculate(luhnLess) == luhnDigit);
   }
  
  String _industry(String number){
    return _INDUSTRY_IDENTIFIER_MAP[number.substring(0, 1)];
  }
  
  toJSON(){
    return stringify({"number": this.cardNumber, "industry": this.cardIndustry, "valid": this.valid});
  }
  
}