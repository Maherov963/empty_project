import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Address extends Equatable {
  int? id;
  String? city;
  String? area;
  String? street;
  String? mark;

  Address({
    this.id,
    this.city,
    this.area = "مساكن برزة",
    this.street,
    this.mark,
  });
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["ID_Address"],
      city: json["City"],
      area: json["Area"],
      street: json["Street"],
      mark: json["Mark"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "ID_Address": id,
      "City": city,
      "Area": area,
      "Street": street,
      "Mark": mark,
    };
  }

  Address copy() {
    return Address(
      area: area,
      city: city,
      mark: mark,
      street: street,
      id: id,
    );
  }

  @override
  List<Object?> get props => [
        id,
        city,
        area,
        street,
        mark,
      ];
}
