class Mistake {
  int wordId;
  int? type;
  int? pos;

  Mistake({
    required this.wordId,
    required this.type,
    this.pos,
  });

  //للتسمبع
  static const int tashkelMistake = 1;
  static const int forgetMistake = 2;
  static const int tajweedMistake = 3;
  static const String tashkel = "خطأ تشكيلي";
  static const String forget = "خطأ حفظي";
  static const String tajweed = "خطأ تجويدي";

  //للسبر
  static const int testTashkelSelfCorrectionMistake = 4;
  static const int testForgetSelfCorrectionMistake = 5;
  static const int testTajweedSelfCorrectionMistake = 6;
  static const int testTashkelMistake = 7;
  static const int testForgetMistake = 8;
  static const int testTajweedMistake = 9;
  static const String testTashkelSelfCorrection = "خطأ تشكيلي صحح لنفسه";
  static const String testForgetSelfCorrection = "خطأ حفظي صحح لنفسه";
  static const String testTajweedSelfCorrection = "خطأ تجويدي صحح لنفسه";
  static const String testTashkel = "خطأ تشكيلي لم يصحح لنفسه";
  static const String testForget = "خطأ حفظي لم يصحح لنفسه";
  static const String testTajweed = "خطأ تجويدي لم يصحح لنفسه";
  bool get isFoget =>
      type == forgetMistake ||
      type == testForgetSelfCorrectionMistake ||
      type == testForgetMistake;
  static const List<String> mistakes = [
    tashkel,
    forget,
    tajweed,
    testTashkelSelfCorrection,
    testForgetSelfCorrection,
    testTajweedSelfCorrection,
    testTashkel,
    testForget,
    testTajweed
  ];
  factory Mistake.fromJson(Map<String, dynamic> json) {
    return Mistake(
      wordId: json['ID_Word'],
      type: int.parse(json['Mistake_Type'].toString()),
      pos: json['Letter_Position'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_Word': wordId,
        "Mistake_Type": type,
        "Letter_Position": pos,
      };

  Mistake copy() {
    return Mistake(
      wordId: wordId,
      type: type,
      pos: pos,
    );
  }
}
