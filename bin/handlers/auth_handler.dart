import 'dart:convert';

import 'package:daravel/databases/database_wrapper.dart';
import 'package:daravel/shelf.dart';
import 'package:daravel/typedef/future_response.dart';

class AuthHandler {
  final Database db;
  const AuthHandler(this.db);

  DaravelResponse register(Request request) async {
    final requestJson = await request.readAsString();
    final requestMap = jsonDecode(requestJson);

    final id = requestMap['id'];
    final name = requestMap['name'];
    final password = requestMap['password'];
    final result = await db.insert(
      "INSERT INTO users (id, name, password) VALUES (?, ?, ?)",
      params: {
        "id": id,
        "name": name,
        "password": password,
      },
    );

    if (!result) {
      final response = jsonEncode({
        "message": "Register failed",
        "data": null,
      });

      return Response.badRequest(body: response);
    }

    final response = jsonEncode({
      "message": "Register success",
      "data": null,
    });

    return Response.ok(response);
  }

  DaravelResponse login(Request request) async {
    final requestJson = await request.readAsString();
    final requestMap = jsonDecode(requestJson);

    final name = requestMap['name'];
    final password = requestMap['password'];

    final userList = await db.select(
      "SELECT * FROM users WHERE name = ?",
      params: {"name": name},
    );

    var response = jsonEncode({
      "message": "Password or username is wrong",
      "data": null,
    });

    if (userList.isEmpty) {
      return Response.unauthorized(response);
    }

    final user = userList.first;
    if (user["password"] != password) {
      return Response.unauthorized(response);
    }

    response = jsonEncode({
      "message": "Login success",
      "data": {
        "name": user["name"],
        "password": user["password"],
      },
    });

    return Response.ok(response);
  }
}
