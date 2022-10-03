import 'package:carrental/configs/cars.config.dart';
import 'package:carrental/configs/configs.dart';
import 'package:carrental/functions/my_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carrental/configs/routes.config.dart' as routes;

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _name = TextEditingController();
  bool isFirst = true;
  bool isloading = false;
  getDetails() async {
    isFirst = false;
    final SharedPreferences sf = await SharedPreferences.getInstance();
    String? name = sf.getString('name');
    String? mobile = sf.getString('mobile');
    _name.text = name ?? "";
    _mobile.text = mobile ?? "";
    setState(() {});
  }

  setDetails() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setString('name', _name.text);
    sf.setString('mobile', _mobile.text);
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    Car car = data["car"];
    DateTime date = data["date"];
    String id = data["id"];
    String title = data["title"];
    int price = data["price"];
    if (isFirst) getDetails();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(title),
      ),
      child: ListView(
        children: [
          Image.asset("assets/${car.image}"),
          Center(
            child: Text("${car.title} at Rs. $price"),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Full Name :"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoTextField(
              placeholder: 'Full Name',
              controller: _name,
              prefix: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.person),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Mobile :"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoTextField(
              placeholder: 'Mobile Number',
              controller: _mobile,
              keyboardType: TextInputType.phone,
              prefix: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.phone),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoButton.filled(
              child: const Text("Book Now"),
              onPressed: () async {
                setState(() {
                  isloading = true;
                });
                var body = await myHttp(
                  context,
                  '$baseUrl/createOrder',
                  {
                    'name': _name.text,
                    'packageId': id,
                    'mobile': _mobile.text,
                    'date': date.toIso8601String(),
                  },
                  statusCode: 201,
                );
                if (body != null) {
                  setDetails();
                  debugPrint(date.toString());
                  showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                            title: const Text("Order Placed"),
                            content: const Text(
                                "Your order has been placed successfully. We will call you soon."),
                            actions: [
                              CupertinoButton(
                                child: const Text("close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      routes.chooseCar, (route) => false);
                                },
                              ),
                            ],
                          ));
                }
                setState(() {
                  isloading = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
