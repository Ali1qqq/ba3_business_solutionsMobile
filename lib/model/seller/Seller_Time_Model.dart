class SellerTimeModel {
  String? firstTimeEnter;
  String? secondTimeEnter;
  String? firstTimeOut;
  String? secondTimeOut;
  String? breakTimeEnter;
  String? breakTimeOut;

  SellerTimeModel({
    this.firstTimeEnter,
    this.secondTimeEnter,
    this.firstTimeOut,
    this.secondTimeOut,
    this.breakTimeEnter,
    this.breakTimeOut,
  });

  SellerTimeModel.fromJson(Map<String, dynamic> json) {
    firstTimeEnter = json['FirstTimeEnter'];
    secondTimeEnter = json['SecondTimeEnter'];
    firstTimeOut = json['FirstTimeOut'];
    secondTimeOut = json['SecondTimeOut'];
    breakTimeEnter = json['breakTimeEnter'];
    breakTimeOut = json['breakTimeOut'];
  }

  Map<String, dynamic> toJson() {
    return {
      'FirstTimeEnter': firstTimeEnter,
      'SecondTimeEnter': secondTimeEnter,
      'FirstTimeOut': firstTimeOut,
      'SecondTimeOut': secondTimeOut,
      'breakTimeEnter': breakTimeEnter,
      'breakTimeOut': breakTimeOut,
    };
  }
}
