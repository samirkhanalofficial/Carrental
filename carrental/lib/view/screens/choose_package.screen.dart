import 'dart:convert';
import 'package:carrental/configs/cars.config.dart';
import 'package:carrental/configs/configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:carrental/configs/routes.config.dart' as routes;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChoosePackage extends StatefulWidget {
  const ChoosePackage({super.key});

  @override
  State<ChoosePackage> createState() => _ChoosePackageState();
}

class _ChoosePackageState extends State<ChoosePackage> {
  bool isFirst = true;
  bool isloading = true;
  bool error = false;
  var packages = [];
  Future getPackages(Car car) async {
    isFirst = false;
    setState(() {
      packages = [];
      isloading = true;
      error = false;
    });

    try {
      Response res =
          await get(Uri.parse('$baseUrl/getAllPackages/${car.title}'));

      if (res.statusCode == 200) {
        packages = await jsonDecode(res.body);
        isloading = false;
        error = false;
        setState(() {});
      } else {
        isloading = false;
        error = true;
        setState(() {});
      }
    } catch (e) {
      setState(() {
        error = true;
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments as Map;
    Car car = data["car"];
    DateTime date = data["date"];
    if (isFirst) getPackages(car);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(car.title),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
              ),
            ),
            const SliverToBoxAdapter(
              child: Text(
                "Packages",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Text(
                "Choose a package for your tour.",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
            isloading
                ? const SliverToBoxAdapter(
                    child: SizedBox(
                        height: 200, child: CupertinoActivityIndicator()),
                  )
                : error
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.error,
                                size: 50,
                              ),
                              Text("Error Connecting to the server.")
                            ],
                          ),
                        ),
                      )
                    : packages.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.error,
                                    size: 50,
                                  ),
                                  Text("No packages Found.")
                                ],
                              ),
                            ),
                          )
                        : const SliverToBoxAdapter(child: SizedBox.shrink()),
            if (packages.isNotEmpty)
              for (var package in packages)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      child: Material(
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(routes.userDetails, arguments: {
                              'car': car,
                              'date': date,
                              'id': package["_id"],
                              "title":
                                  "${package["source"]} to ${package["destination"]}",
                              "price": package["price"],
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Hero(
                                    tag: car.image,
                                    child: Image.asset(
                                      "assets/${car.image}",
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${package["source"]} to ${package["destination"]}",
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "RS. ${package["price"]} ",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
