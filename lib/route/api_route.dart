import 'package:vania/vania.dart';
import 'package:join_vania/app/http/controllers/auth_controller.dart';
import 'package:join_vania/app/http/controllers/user_controller.dart';
import 'package:join_vania/app/http/middleware/authenticate.dart';
import 'package:join_vania/app/http/controllers/customer_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');
    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');
    Router.group(() {
      Router.patch('update-password', userController.updatePassword);
      Router.get('', userController.index);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);

    // API
    Router.post('customers', customerController.create);
    Router.get('customers', customerController.show);
    Router.put('customers/{cust_id}', customerController.update);
    Router.delete('customers/{id}', customerController.destroy);
  }
}
