import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:http/http.dart';
import '../../errors/exceptions.dart';
import 'links.dart';

abstract class GroupRemoteDataSource {
  Future<Unit> addGroup(Group group, String authToken);
  Future<Unit> editGroup(Group group, String authToken);
  Future<Unit> deleteGroup(int id, String authToken);
  Future<Unit> setDefaultGroup(int? id, String authToken);
  Future<Group> getGroup(int id, String authToken);
  Future<List<Group>> getAllGroup(String authToken);
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final Client client;

  GroupRemoteDataSourceImpl(this.client);
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
  Future<Unit> deleteGroup(int id, String authToken) {
    return Future.delayed(
      const Duration(seconds: 3),
      () {
        return unit;
      },
    );
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
}
