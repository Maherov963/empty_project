class CustomState {
  final int id;
  final String state;

  const CustomState({
    required this.id,
    required this.state,
  });

  static const String notActive = "غير نشط"; // 1
  static const String active = "نشط"; // 2
  static const String alive = "على قيد الحياة"; // 3
  static const String died = "متوفى"; // 4
  static const String other = "غير ذلك"; // 5

  static const int notActiveId = 1;
  static const int activeId = 2;
  static const int aliveId = 3;
  static const int diedId = 4;
  static const int otherId = 5;

  static const List<String> states = [notActive, active, alive, died, other];
  static const List<String> personStates = [alive, died, other];
  static const List<String> activationStates = [active, notActive];

  static String? getStateFromId(int? id) {
    return switch (id) {
      notActiveId => notActive,
      activeId => active,
      aliveId => alive,
      diedId => died,
      otherId => other,
      int() => null,
      null => null,
    };
  }

  static int? getIdFromState(String? state) {
    return switch (state) {
      notActive => notActiveId,
      active => activeId,
      alive => aliveId,
      died => diedId,
      other => otherId,
      String() => null,
      null => null,
    };
  }
}
