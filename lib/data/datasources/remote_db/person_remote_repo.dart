import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:http/http.dart';
import '../../errors/exceptions.dart';
import 'links.dart';

abstract class PersonRemoteDataSource {
  Future<int> addPerson(Person person, String authToken);
  Future<Unit> addPermission(Custom custom, String authToken);
  Future<Unit> addStudent(Student student, String authToken);
  Future<Unit> editPerson(Person person, String authToken);
  Future<Unit> editStudent(Student student, String authToken);
  Future<Unit> editPermission(Custom custom, String authToken);
  Future<Unit> deletePerson(
    int id,
    String authToken,
  );
  Future<List<Person>> getTheAllPerson(String authToken);
  Future<Person> getPerson(int id, String authToken);
  Future<List<Person>> getAllPerson(String authToken, {Person? person});
  Future<List<Person>> getSupervisors(String authToken);
  Future<List<Person>> getModerators(String authToken);
  Future<List<Person>> getAssistants(String authToken);
  Future<List<Person>> getTesters(String authToken);
  Future<List<Person>> getStudentsForTesters(String authToken);
  Future<Unit> addImage(String imageLink, String authToken, int id);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final Client client;

  PersonRemoteDataSourceImpl(this.client);
  @override
  Future<int> addPerson(Person person, String authToken) async {
    var body = person.toJson();
    body.addAll({
      "api_password": apiPassword,
    });
    var res = await client
        .post(
          Uri.parse(addPersonLink),
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
        return mapData["personID"];
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Unit> editPerson(Person person, String authToken) async {
    var body = person.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(updatePersonLink),
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
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Unit> addImage(String imageLink, String authToken, int id) async {
    var request = MultipartRequest("POST", Uri.parse(addImageLink));
    MultipartFile multipartFile =
        await MultipartFile.fromPath('Image_URL', imageLink);
    request.headers.addAll({
      "auth-token": authToken,
      "Content-Type": "application/json",
    });
    request.fields.addAll({
      "api_password": apiPassword,
      "ID_Person": id.toString(),
    });
    request.files.add(multipartFile);
    var response = await request.send().timeout(
          const Duration(seconds: 30),
        );

    var res2 = await Response.fromStream(response);
    if (res2.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res2.body);
      if (mapData["errNum"] == "S000") {
        return unit;
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res2.body);
    }
  }

  @override
  Future<Unit> deletePerson(
    int id,
    String authToken,
  ) async {
    var res = await client
        .post(
          Uri.parse(deletePersonLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode(
            {
              "api_password": apiPassword,
              "ID_Person": id,
            },
          ),
        )
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return unit;
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<Person>> getAllPerson(String authToken, {Person? person}) async {
    Map<String, dynamic> body;
    if (person == null) {
      body = {"api_password": apiPassword};
    } else {
      body = person.toJson();
      body.addAll({"api_password": apiPassword});
    }
    var res = await client
        .post(
          Uri.parse(viewAllPeopleLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 60),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List perople = mapData["people"];
        return perople.map((e) => Person.fromJson(e)).toList()
          ..sort(
            (a, b) => a.getFullName().compareTo(b.getFullName()),
          );
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Person> getPerson(
    int id,
    String authToken,
  ) async {
    var res = await client
        .post(
          Uri.parse(viewPersonLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
            "id": id,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return Person.fromJson(mapData["person"]);
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Unit> addPermission(Custom custom, String authToken) async {
    var body = custom.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(addPermissionLink),
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
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Unit> addStudent(Student student, String authToken) async {
    var body = student.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(appointStudentLink),
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
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Unit> editStudent(Student student, String authToken) async {
    var body = student.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(editStudentLink),
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
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<Unit> editPermission(Custom custom, String authToken) async {
    var body = custom.toJson();
    body.addAll({"api_password": apiPassword});
    var res = await client
        .post(
          Uri.parse(editPermissionLink),
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
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<Person>> getAssistants(String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewAssistantsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List assistants = mapData["people"];
        return assistants.map((e) => Person.fromJson(e)).toList();
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<Person>> getModerators(String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewModeratorsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List moderators = mapData["people"];
        return moderators.map((e) => Person.fromJson(e)).toList();
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<Person>> getSupervisors(String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewSupervisorsLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List supervisors = mapData["people"];
        return supervisors.map((e) => Person.fromJson(e)).toList();
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<Person>> getTheAllPerson(String authToken) async {
    var res = await client
        .post(
          Uri.parse(viewTheAllPeopleLink),
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
        final List perople = mapData["people"];
        return perople.map((e) => Person.fromJson(e)).toList();
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<Person>> getTesters(String authToken) async {
    Response res = await client
        .post(
          Uri.parse(viewTestersLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List supervisors = mapData["people"];
        return supervisors.map((e) => Person.fromJson(e)).toList();
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }

  @override
  Future<List<Person>> getStudentsForTesters(String authToken) async {
    Response res = await client
        .post(
          Uri.parse(viewStudentsForTestersLink),
          headers: {
            "auth-token": authToken,
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "api_password": apiPassword,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    // print(res.body);
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        final List supervisors = mapData["students"];
        return supervisors.map((e) => Person.fromJson(e)).toList();
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }
}
