import 'package:carrental/configs/configs.dart';
import 'package:carrental/functions/my_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carrental/configs/routes.config.dart' as routes;

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  routetoAdminDashboard() {
    Navigator.of(context).pushNamed(routes.adminDashboard);
  }

  checklogin() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    String? accessToken = sf.getString('access_token');
    if ((accessToken != null) && accessToken.isNotEmpty) {
      try {
        Response res = await get(Uri.parse("$baseUrl/me"), headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });
        if (res.statusCode == 401) {
          throw 'Login expired, Please login again.';
        } else if (res.statusCode == 200) {
          routetoAdminDashboard();
        } else {
          throw 'error connecting to server';
        }
      } catch (e) {
        showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  title: const Text("Error"),
                  content: Text(e.toString()),
                  actions: [
                    CupertinoButton(
                      child: const Text("close"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ));
      }
    }
  }

  @override
  void initState() {
    checklogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Admin Login"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Hero(
                tag: 'logo',
                child: Image.asset('assets/logo.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("email :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                placeholder: 'email',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.at),
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("password :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _password,
                placeholder: 'password',
                obscureText: true,
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.lock),
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            CupertinoButton.filled(
              child: const Text("Login"),
              onPressed: () async {
                var body = await myHttp(
                  context,
                  '$baseUrl/login',
                  {
                    'email': _email.text,
                    'password': _password.text,
                  },
                  statusCode: 201,
                );
                SharedPreferences sf = await SharedPreferences.getInstance();
                sf.setString('access_token', body['access_token'].toString());
                routetoAdminDashboard();
              },
            ),
          ],
        ),
      ),
    );
  }
}
