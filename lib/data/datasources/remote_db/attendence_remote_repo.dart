import 'dart:convert';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'links.dart';

abstract class AttendenceRemoteDataSource {
  Future<Unit> attendence(Attendence attendence, String authToken);
  Future<Attendence> viewAttendence(String date, int groupId, String authToken);
  Future<List<StudentAttendece>> viewStudentAttendence(
      int personId, String authToken);
}

class AttendenceRemoteDataSourceImpl implements AttendenceRemoteDataSource {
  final Client client;

  AttendenceRemoteDataSourceImpl(this.client);

  @override
  Future<Unit> attendence(Attendence attendence, String authToken) async {
    var body = attendence.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(attendenceLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return unit;
      } else if (mapData["errNum"] == "S111") {
        throw UpdateException(message: mapData["msg"].toString());
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Attendence> viewAttendence(
      String date, int groupId, String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewAttendenceLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "attendenceDate": date,
            "Group": groupId,
          }),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return Attendence.fromJson(mapData["attendance"]);
      } else if (mapData["errNum"] == "S111") {
        throw UpdateException(message: mapData["msg"].toString());
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<StudentAttendece>> viewStudentAttendence(
      int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewStudentAttendenceLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Person": id,
          }),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List attendence = mapData["attendance"];
        return attendence.map((e) => StudentAttendece.fromJson(e)).toList()
          ..sort(
            (a, b) => a.attendenceDate!.compareTo(b.attendenceDate!),
          );
      } else if (mapData["errNum"] == "S111") {
        throw UpdateException(message: mapData["msg"].toString());
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }
}
