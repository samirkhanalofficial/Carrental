import 'package:carrental/configs/cars.config.dart';
import 'package:carrental/configs/configs.dart';
import 'package:carrental/functions/my_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPackageAdmin extends StatefulWidget {
  const AddPackageAdmin({super.key});

  @override
  State<AddPackageAdmin> createState() => _AddPackageAdminState();
}

class _AddPackageAdminState extends State<AddPackageAdmin> {
  final TextEditingController _source = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _price = TextEditingController();
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
    final Car car = ModalRoute.of(context)!.settings.arguments as Car;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Add Package "),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Image.asset('assets/${car.image}'),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  car.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Source :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _source,
                placeholder: 'Source',
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.location_solid),
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Destination :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _destination,
                placeholder: 'Destination',
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.location_circle),
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Price :"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _price,
                placeholder: 'Price in Rs',
                keyboardType: TextInputType.number,
                prefix: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(CupertinoIcons.money_dollar_circle),
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
                      double priceTemp = double.parse(
                          _price.text.isNotEmpty ? _price.text : '0');
                      var body = await myHttp(
                        context,
                        '$baseUrl/createPackage',
                        {
                          "source": _source.text,
                          "destination": _destination.text,
                          "price": priceTemp,
                          "vehicleType": car.title
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
                            title: const Text("Package Added"),
                            content: const Text(
                                "Package has been added successfully"),
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
