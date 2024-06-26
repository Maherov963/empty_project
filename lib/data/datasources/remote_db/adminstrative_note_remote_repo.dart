import 'dart:developer';

import 'package:al_khalil/domain/models/management/adminstrative_note.dart';
import '../../errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'links.dart';

abstract class AdminstrativeNoteRemoteDataSource {
  Future<int> addAdminstrativeNote(
      AdminstrativeNote adminstrativeNote, String authToken);
  Future<Unit> editAdminstrativeNote(
      AdminstrativeNote adminstrativeNote, String authToken);
  Future<Unit> deleteAdminstrativeNote(int id, String authToken);
  Future<List<AdminstrativeNote>> viewAdminstrativeNote(
    AdminstrativeNote adminstrativeNote,
    String authToken,
  );
}

class AdminstrativeNoteRemoteDataSourceImpl
    implements AdminstrativeNoteRemoteDataSource {
  final Client client;

  AdminstrativeNoteRemoteDataSourceImpl(this.client);

  @override
  Future<int> addAdminstrativeNote(
      AdminstrativeNote adminstrativeNote, String authToken) async {
    var body = adminstrativeNote.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(addAdminstrativeNoteLinks),
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
      log(res.body);
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return mapData["id"];
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
  Future<Unit> deleteAdminstrativeNote(int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(deleteAdminstrativeNoteLinks),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Adminstrative_Note": id,
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
  Future<Unit> editAdminstrativeNote(
    AdminstrativeNote adminstrativeNote,
    String authToken,
  ) async {
    var body = adminstrativeNote.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(editAdminstrativeNoteLinks),
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
  Future<List<AdminstrativeNote>> viewAdminstrativeNote(
      AdminstrativeNote adminstrativeNote, String authToken) async {
    var body = adminstrativeNote.toJson();
    body.addAll({"api_password": apiPassword});
    log(body.toString());
    var res = await client
        .post(
          Uri.parse(viewAdminstrativeNoteLinks),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    log(res.body);
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List groups = mapData["notes"];
        return groups.map((e) => AdminstrativeNote.fromJson(e)).toList();
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
