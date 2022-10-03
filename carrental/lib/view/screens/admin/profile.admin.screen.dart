import 'dart:convert';

import 'package:carrental/configs/configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carrental/configs/routes.config.dart' as routes;

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool isloading = true, error = false;
  var me = {};
  var admins = [];
  Future fetchAll() async {
    await getMe();
    await getAdmins();
  }

  Future getMe() async {
    me["name"] = "xxxx";
    me["email"] = "xxxx@xxx.xxx";
    setState(() {
      isloading = true;
      error = false;
    });
    try {
      SharedPreferences sf = await SharedPreferences.getInstance();
      String accessToken = sf.getString('access_token')!;
      Response res = await get(Uri.parse("$baseUrl/me"), headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      });
      if (res.statusCode == 200) {
        me = jsonDecode(res.body);
        setState(() {
          isloading = false;
          error = false;
        });
      } else {
        throw '';
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isloading = false;
        error = true;
      });
    }
  }

  Future getAdmins() async {
    setState(() {
      isloading = true;
      error = false;
    });
    try {
      SharedPreferences sf = await SharedPreferences.getInstance();
      String accessToken = sf.getString('access_token')!;
      Response res = await get(Uri.parse("$baseUrl/admins"), headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      });
      if (res.statusCode == 200) {
        admins = jsonDecode(res.body);
        setState(() {
          isloading = false;
          error = false;
        });
      } else {
        throw '';
      }
    } catch (e) {
      setState(() {
        isloading = false;
        error = true;
      });
    }
  }

  @override
  void initState() {
    fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Profile"),
        trailing: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Text("Logout"),
          onPressed: () => logout(),
        ),
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
              await fetchAll();
            }),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 70,
              ),
            ),
            const SliverToBoxAdapter(
              child: Center(
                child: Icon(
                  CupertinoIcons.profile_circled,
                  size: 100,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Text(
                  me["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                  child: Text(
                me["email"],
                style: const TextStyle(fontSize: 13),
              )),
            ),
            SliverToBoxAdapter(
              child: CupertinoButton(
                onPressed: () => routeToHome(),
                child: const Text("Leave Admin"),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      Text(
                        "Admins",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        "List of all admins",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  CupertinoButton(
                      child: Row(
                        children: const [
                          Icon(CupertinoIcons.add_circled),
                          Text("Add new "),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(routes.registerAdmin);
                      }),
                ],
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
                    : me.isEmpty
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
                                  Text("No data found.")
                                ],
                              ),
                            ),
                          )
                        : const SliverToBoxAdapter(child: SizedBox.shrink()),
            if (admins.isNotEmpty)
              for (var admin in admins)
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
                                const SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Icon(
                                    CupertinoIcons.profile_circled,
                                    size: 45,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${admin["name"]}",
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${admin["email"]} ",
                                        style: const TextStyle(
                                          fontSize: 13,
                                        ),
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
                                          title: const Text("Remove Admin "),
                                          content: Text(
                                              "Are you sure you want to remove  ${admin["name"]}' from admin ?"),
                                          actions: [
                                            CupertinoButton(
                                              child: const Text("No"),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                            CupertinoButton(
                                              child: const Text("Remove"),
                                              onPressed: () async {
                                                SharedPreferences sf =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String accessToken = sf
                                                    .getString('access_token')!;
                                                Response res = await delete(
                                                    Uri.parse(
                                                        '$baseUrl/deleteAdmin/${admin["_id"]}'),
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
                                                        "Admin Removed",
                                                      ),
                                                      content: Text(
                                                        " ${admin["name"]} is removed from admins Successfully.",
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
                                                            getAdmins();
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
                                                        "Failed to Remove",
                                                      ),
                                                      content: Text(
                                                        " ${admin["name"]} could not be removed.",
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

  logout() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout ?"),
        actions: [
          CupertinoButton(
            child: const Text("No"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoButton(
            child: const Text("Logout"),
            onPressed: () async {
              SharedPreferences sf = await SharedPreferences.getInstance();
              sf.remove('access_token');
              routeToHome();
            },
          ),
        ],
      ),
    );
  }

  routeToHome() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(routes.chooseCar, (route) => false);
  }
}
