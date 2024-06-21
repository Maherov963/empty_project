import 'package:al_khalil/domain/models/models.dart';
import '../../errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'links.dart';

abstract class GroupRemoteDataSource {
  Future<Unit> addGroup(Group group, String authToken);
  Future<Unit> editGroup(Group group, String authToken);
  Future<Unit> deleteGroup(int id, String authToken);
  Future<Unit> setDefaultGroup(int? id, String authToken);
  Future<Group> getGroup(int id, String authToken);
  Future<List<Group>> getAllGroup(String authToken);

  Future<Unit> moveStudents(
      List<Student> students, int group, String authToken);
  Future<Unit> evaluateStudents(List<Student> students, String authToken);
  Future<Unit> setStudentsState(
      List<Student> students, int state, String authToken);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final Client client;

  const GroupRemoteDataSourceImpl(this.client);

  @override
  Future<Unit> addGroup(Group group, String authToken) async {
    var body = group.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(addGroupLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 30),
        );
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
  Future<Unit> deleteGroup(int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(deleteGroupLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Group": id,
          }),
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
  Future<Unit> editGroup(Group group, String authToken) async {
    var body = group.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(editGroupLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 30),
        );
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
  Future<List<Group>> getAllGroup(String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewGroupsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({"api_password": apiPassword}),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List groups = mapData["groups"];
        return groups.map((e) => Group.fromJson(e)).toList()
          ..sort(
            (a, b) {
              return (a.groupName ?? "").compareTo(b.groupName ?? "");
            },
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

  @override
  Future<Group> getGroup(int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewGroupLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Group": id,
          }),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return Group.fromJson(mapData["group"]);
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
  Future<Unit> setDefaultGroup(int? id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(setDefaultGroupLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "Default_Group": id,
          }),
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
  Future<Unit> evaluateStudents(
      List<Student> students, String authToken) async {
    var res = await client
        .post(
          Uri.parse(evaluateStudentsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "students": students.map((e) => e.toJson()).toList(),
          }),
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
  Future<Unit> moveStudents(
      List<Student> students, int group, String authToken) async {
    var res = await client
        .post(
          Uri.parse(moveStudentsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Group": group,
            "students": students.map((e) => e.toJson()).toList(),
          }),
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
  Future<Unit> setStudentsState(
      List<Student> students, int state, String authToken) async {
    var res = await client
        .post(
          Uri.parse(setStudentsStateLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "State": state,
            "students": students.map((e) => e.toJson()).toList(),
          }),
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
}
