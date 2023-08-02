import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class User extends Equatable {
  int? id;
  String? userName;
  String? passWord;

  User({this.userName, this.passWord, this.id = 0});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json["UserName"],
      passWord: json["password"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "UserName": userName,
      "password": passWord,
    };
  }

  User copy() {
    return User(
      passWord: passWord,
      userName: userName,
    );
  }

  @override
  List<Object?> get props => [userName, passWord];
}
