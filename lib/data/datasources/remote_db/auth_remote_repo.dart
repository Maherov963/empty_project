import 'dart:convert';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:http/http.dart';
import 'links.dart';

abstract class AuthRemoteDataSource {
  Future<Person> logIn(User user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Client client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Person> logIn(User user) async {
    var body = user.toJson();
    body.addAll({"api_password": apiPassword});
    var ebody = json.encode(body);
    var res = await client
        .post(
          Uri.parse(logInLink),
          headers: {
            "Content-Type": "application/json",
          },
          body: ebody,
        )
        .timeout(
          const Duration(seconds: 30),
        );
    if (res.statusCode == 200) {
      final Map<String, dynamic> mapData = jsonDecode(res.body);
      if (mapData["errNum"] == "S000") {
        return Person.fromJson(mapData["user"]);
      } else {
        throw WrongAuthException(message: mapData["msg"].toString());
      }
    } else {
      throw ServerException(message: res.body);
    }
  }
}
