import 'dart:convert';
import 'dart:developer';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'links.dart';

abstract class MemorizationRemoteDataSource {
  Future<Memorization> viewMemorization(int id, String authToken);
  Future<int> recite(Reciting reciting, String authToken);
  Future<int> test(QuranTest quranTest, String authToken);
  Future<Unit> editTest(QuranTest quranTest, String authToken);
  Future<Unit> editRecite(Reciting reciting, String authToken);
  Future<Unit> deleteRecite(int id, String authToken);
  Future<Unit> deleteTest(int id, String authToken);
  Future<List<Person>> getTestsInDateRange(
      String? firstDate, String? lastDate, String authToken);
}

class MemorizationRemoteDataSourceImpl implements MemorizationRemoteDataSource {
  final Client client;

  MemorizationRemoteDataSourceImpl(this.client);

  @override
  Future<Memorization> viewMemorization(int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewMemorizationLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Student_Pep": id,
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return Memorization.fromJson(mapData["res"]);
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
  Future<Unit> editRecite(Reciting reciting, String authToken) async {
    var body = reciting.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(editReciteLink),
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
  Future<Unit> editTest(QuranTest quranTest, String authToken) async {
    var body = quranTest.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(editTestLink),
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
  Future<int> recite(Reciting reciting, String authToken) async {
    var body = reciting.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(reciteLink),
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
        return mapData["reciting_id"];
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
  Future<int> test(QuranTest quranTest, String authToken) async {
    Map<String, dynamic> body = quranTest.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(testLink),
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
        return mapData["test"]["ID_Test"];
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
  Future<Unit> deleteRecite(int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(deleteReciteLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Reciting": id,
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
  Future<Unit> deleteTest(int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(deleteTestLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "ID_Test": id,
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
  Future<List<Person>> getTestsInDateRange(
      String? firstDate, String? lastDate, String authToken) async {
    Response res = await client
        .post(
          Uri.parse(testsInDateRangeLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "StartDate": firstDate,
            "EndDate": lastDate,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    log(res.body);
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List persons = mapData["tests"];
        return persons.map((e) => Person.fromJson(e)).toList();
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
