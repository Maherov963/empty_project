import '../management/person.dart';

class AdditionalPoints {
  int? id;
  String? note;
  int? points;
  String? createdAt;
  Person? senderPer;
  Person? recieverPep;

  AdditionalPoints({
    this.id,
    this.note,
    this.points,
    this.createdAt,
    this.senderPer,
    this.recieverPep,
  });

  factory AdditionalPoints.fromJson(Map<String, dynamic> json) {
    return AdditionalPoints(
      note: json['Note'],
      id: json['ID_Additional_Points'],
      points: json['Points'],
      createdAt: json['Created_At'],
      senderPer: Person.fromJson(json['Sender_Per']),
      recieverPep: Person.fromJson(json['Receiver_Pep']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Note': note,
      'ID_Additional_Points': id,
      'Points': points,
      'Created_At': createdAt,
      'Sender_Per': {
        "ID_Person": senderPer?.id,
        "First_Name": senderPer?.firstName,
        "Last_Name": senderPer?.lastName,
      },
      'Receiver_Pep': {
        "ID_Person": recieverPep?.id,
        "First_Name": recieverPep?.firstName,
        "Last_Name": recieverPep?.lastName,
      },
    };
  }

  AdditionalPoints copyWith() {
    return AdditionalPoints(
      id: id,
      note: note,
      points: points,
      createdAt: createdAt,
      senderPer: senderPer?.copy(),
      recieverPep: recieverPep?.copy(),
    );
  }
}
