import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class IdNameModel extends Equatable {
  static const int asAdmin = 0;
  static const int asModerator = 1;
  static const int asAssistant = 2;
  static const int asSupervisor = 3;
  static const int asWatcher = 4;
  static const int asTester = 5;
  int? id;
  String? name;
  bool val;
  int? myRank;
  IdNameModel({
    this.id,
    this.name,
    this.myRank,
    this.val = false,
  });

  IdNameModel copy() {
    return IdNameModel(
      id: id,
      name: name,
      val: val,
      myRank: myRank,
    );
  }

  factory IdNameModel.fromJson(
    Map<String, dynamic>? json, {
    String idKey = "id",
    String nameKey = "name",
  }) {
    return IdNameModel(
      id: json == null ? null : json[idKey],
      name: json == null ? null : json[nameKey],
    );
  }
  Map<String, dynamic>? toJson({
    String idKey = "id",
    String nameKey = "name",
  }) {
    //id == null && name == null
    //    ? null
    //    :
    return {
      idKey: id,
      nameKey: name,
    };
  }

  @override
  List<Object?> get props => [id];
}
