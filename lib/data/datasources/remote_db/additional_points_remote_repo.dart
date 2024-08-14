import 'dart:convert';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import '../../../domain/models/additional_points/addional_point.dart';
import 'links.dart';

abstract class AdditionalPointsRemoteDataSource {
  Future<List<AdditionalPoints>> viewAddionalPoints(
      AdditionalPoints additionalPoints, String authToken);
  Future<Unit> setExchange(int price, String authToken);
  Future<Unit> addEachAdditionalPoints(
      List<AdditionalPoints> additionalPoint, String authToken);
  Future<int> getExchange(String authToken);
  Future<int> addAdditionalPoints(
      AdditionalPoints additionalPoints, String authToken);
  Future<Unit> editAdditionalPoints(
      AdditionalPoints additionalPoints, String authToken);
  Future<Unit> deleteAdditionalPoints(int id, String authToken);
}

class AdditionalPointsRemoteDataSourceImpl
    implements AdditionalPointsRemoteDataSource {
  final Client client;

  AdditionalPointsRemoteDataSourceImpl(this.client);

  @override
  Future<int> addAdditionalPoints(
      AdditionalPoints additionalPoints, String authToken) async {
    var body = additionalPoints.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(addAdditionalPointsLink),
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
        return mapData["ID_Additional_Points"];
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
  Future<List<AdditionalPoints>> viewAddionalPoints(
      AdditionalPoints additionalPoints, String authToken) async {
    var body = additionalPoints.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(viewAdditionalPointsLink),
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
        final List addPtsList = mapData["additional_points"];
        return addPtsList.map((e) => AdditionalPoints.fromJson(e)).toList();
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
  Future<Unit> editAdditionalPoints(
      AdditionalPoints additionalPoints, String authToken) async {
    var body = additionalPoints.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(editAdditionalPointsLink),
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
  Future<Unit> deleteAdditionalPoints(int id, String authToken) async {
    var res = await client
        .post(
          Uri.parse(deleteAdditionalPointsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode(
            {
              "api_password": apiPassword,
              "ID_Additional_Points": id,
            },
          ),
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
  Future<int> getExchange(String authToken) async {
    var res = await client
        .post(
          Uri.parse(getPointExchangeLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({"api_password": apiPassword}),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final int value = int.parse(mapData["Price"].toString());
        return value;
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
  Future<Unit> setExchange(int price, String authToken) async {
    var res = await client
        .post(
          Uri.parse(setPointExchangeLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "Price": price,
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
  Future<Unit> addEachAdditionalPoints(
      List<AdditionalPoints> additionalPoint, String authToken) async {
    var res = await client
        .post(
          Uri.parse(addAdditionalPointsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "additionalPoint": additionalPoint.map((e) => e.toJson()).toList(),
          }),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return mapData["ID_Additional_Points"];
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
