import 'package:daravel/databases/database_wrapper.dart';
import 'package:daravel/models/connection_model.dart';
import 'package:daravel/router/router.dart';
import 'package:daravel/shelf.dart';
import 'package:daravel/utils/select_sql_driver.dart';

import 'handlers/auth_handler.dart';

void main(List<String> arguments) async {
  final db = Database(selectSqlDriver(arguments));
  // ? POSTGRESQL
  await db.connect(
    ConnectionModel(
      host: "localhost",
      database: "postgres",
      username: "postgres",
      password: "123456",
      port: 5555,
    ),
  );

  // ? Auth Handler
  final AuthHandler authHandler = AuthHandler(db);

  DaravelRouter router = DaravelRouter();

  router.get("", (request) async => Response.ok("Hello World"));

  // ? Auth Router
  final auth = router.group('auth');
  auth.post('login', authHandler.login);
  auth.post('register', authHandler.register);

  router.serve('localhost', 9999);
}
