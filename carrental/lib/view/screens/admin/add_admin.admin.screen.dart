import 'package:carrental/configs/configs.dart';
import 'package:carrental/functions/my_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordc = TextEditingController();
  late SharedPreferences? sf;
  bool isloading = false;
  initmy() async {
    sf = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initmy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Add Admin "),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Center(
              child: Icon(
                CupertinoIcons.profile_circled,
                size: 100,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Full Name :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _name,
                placeholder: 'Full Name',
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.person),
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Email :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _email,
                placeholder: 'Email',
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
              child: Text("Password :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _password,
                placeholder: 'Password',
                obscureText: true,
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.lock),
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Confirm Password :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _passwordc,
                placeholder: 'Confirm Password',
                obscureText: true,
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.lock),
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            isloading
                ? const SizedBox(
                    height: 100,
                    child: Center(child: CupertinoActivityIndicator()),
                  )
                : CupertinoButton.filled(
                    child: const Text("Add"),
                    onPressed: () async {
                      setState(() {
                        isloading = true;
                      });
                      String accessToken = sf!.getString('access_token')!;
                      if (_password.text != _passwordc.text) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text("Error"),
                            content: const Text(
                                "Confirmation Password must be same as Password."),
                            actions: [
                              CupertinoButton(
                                child: const Text("close"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );

                        setState(() {
                          isloading = false;
                        });
                        return;
                      }
                      var body = await myHttp(
                        context,
                        '$baseUrl/register',
                        {
                          "email": _email.text,
                          "password": _password.text,
                          "name": _name.text,
                        },
                        header: {
                          'Authorization': 'Bearer $accessToken',
                          'Content-Type': 'application/json'
                        },
                        statusCode: 201,
                      );
                      setState(() {
                        isloading = false;
                      });
                      if (body != null) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text("Admin Added"),
                            content: const Text("Admin added successfully"),
                            actions: [
                              CupertinoButton(
                                child: const Text("close"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                      debugPrint(body.toString());
                    },
                  )
          ],
        ),
      ),
    );
  }
}
