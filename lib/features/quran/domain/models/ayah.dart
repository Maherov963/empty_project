class Ayah {
  final String ayah;
  final int ayahId;
  final int pageId;
  final String suraName;

  const Ayah({
    required this.ayah,
    required this.ayahId,
    required this.pageId,
    required this.suraName,
  });
  factory Ayah.fromJson(Map json, {int pageId = 0}) {
    return Ayah(
      ayahId: json["ayahId"],
      ayah: json["ayah"],
      suraName: json["suraName"],
      pageId: pageId,
    );
  }
}
