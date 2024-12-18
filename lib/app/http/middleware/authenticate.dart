import 'package:vania/vania.dart';
import 'dart:io';

class AuthenticateMiddleware extends Authenticate {}

Future<Response> me() async {
  Map? user = Auth().user();

  if (user != null) {
    user.remove('password');
    return Response.json({
      "message": "success",
      "data": user,
    }, HttpStatus.ok);
  }

  return Response.json({
    "message": "success",
    "data": "",
  }, HttpStatus.notFound);
}
