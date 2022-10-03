import 'dart:convert';

import 'package:carrental/configs/cars.config.dart';
import 'package:carrental/configs/configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:carrental/configs/routes.config.dart' as routes;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int active = 0;
  bool isloading = true;
  bool error = false;
  var packages = [];
  Future getPackages() async {
    setState(() {
      packages = [];
      isloading = true;
      error = false;
    });

    try {
      Response res =
          await get(Uri.parse('$baseUrl/getAllPackages/${cars[active].title}'));

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
  void initState() {
    getPackages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Icon(CupertinoIcons.cart),
          onPressed: () {
            Navigator.of(context).pushNamed(routes.adminOrders);
          },
        ),
        middle: const Text("Dashboard"),
        trailing: CupertinoButton(
            padding: const EdgeInsets.all(0),
            child: const Icon(CupertinoIcons.person),
            onPressed: () {
              Navigator.of(context).pushNamed(routes.adminProfile);
            }),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(onRefresh: () async {
              debugPrint("refreshed");
              await getPackages();
            }),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 70,
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Packages",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  CupertinoButton(
                      child: Row(
                        children: const [
                          Icon(CupertinoIcons.add_circled),
                          Text("Add new "),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(routes.adminAddPackage,
                            arguments: cars[active]);
                      }),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cars.length,
                  itemBuilder: ((context, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: active == i
                              ? const Color.fromARGB(255, 110, 145, 204)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(18),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                active = i;
                              });
                              getPackages();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset(
                                          'assets/${cars[i].image}')),
                                  Text(
                                    cars[i].title,
                                    style: TextStyle(
                                      color: active == i
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
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
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Hero(
                                    tag: cars[active].image,
                                    child: Image.asset(
                                      "assets/${cars[active].image}",
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
                                        "${package["vehicleType"]} at RS. ${package["price"]} ",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.all(0),
                                    child: const Icon(
                                      CupertinoIcons.trash_circle,
                                      color: Colors.red,
                                      size: 45,
                                    ),
                                    onPressed: () {
                                      showCupertinoDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) =>
                                            CupertinoAlertDialog(
                                          title: const Text("Delete "),
                                          content: Text(
                                              "Are you sure you want to delete ' ${package["source"]} to ${package["destination"]} ' ?"),
                                          actions: [
                                            CupertinoButton(
                                              child: const Text("No"),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                            CupertinoButton(
                                              child: const Text("Delete"),
                                              onPressed: () async {
                                                SharedPreferences sf =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String accessToken = sf
                                                    .getString('access_token')!;
                                                Response res = await delete(
                                                    Uri.parse(
                                                        '$baseUrl/deletePackage/${package["_id"]}'),
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer $accessToken',
                                                      'Content-Type':
                                                          'application/json'
                                                    });
                                                if (res.statusCode == 200) {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (context) =>
                                                        CupertinoAlertDialog(
                                                      title: const Text(
                                                        "Deleted",
                                                      ),
                                                      content: Text(
                                                        "' ${package["source"]} to ${package["destination"]} ' deleted Successfully.",
                                                      ),
                                                      actions: [
                                                        CupertinoButton(
                                                          child: const Text(
                                                              "Close"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            getPackages();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        CupertinoAlertDialog(
                                                      title: const Text(
                                                        "Failed to Delete",
                                                      ),
                                                      content: Text(
                                                        "' ${package["source"]} to ${package["destination"]} ' could not be deleted.",
                                                      ),
                                                      actions: [
                                                        CupertinoButton(
                                                          child: const Text(
                                                              "Close"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
