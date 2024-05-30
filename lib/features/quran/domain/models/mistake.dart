class Mistake {
  int idWord;
  int type;
  int? pos;

  Mistake({
    required this.idWord,
    required this.type,
    this.pos,
  });

  //للتسمبع
  static const int tashkelMistake = 1;
  static const int forgetMistake = 2;
  static const int tajweedMistake = 3;

  //للسبر
  static const int testTashkelSelfCorrectMistake = 4;
  static const int testForgetSelfCorrectMistake = 5;
  static const int testTajweedSelfCorrectMistake = 6;
  static const int testTashkelMistake = 7;
  static const int testForgetMistake = 8;
  static const int testTajweedMistake = 9;

  Mistake copy() {
    return Mistake(
      idWord: idWord,
      type: type,
      pos: pos,
    );
  }
}
