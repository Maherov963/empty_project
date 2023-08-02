class Chart {
  final int x;
  final int y;

  const Chart({required this.x, required this.y});

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(x: json["x"], y: json["y"]);
  }
}
