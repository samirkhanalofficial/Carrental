import 'dart:convert';

import 'package:carrental/configs/configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../configs/cars.config.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isloading = true, error = false;
  var modes = ['All Products', 'Pending Orders', 'Completed Orders'];
  int active = 0;
  var orders = [];
  Future getOrders() async {
    setState(() {
      isloading = true;
      error = false;
    });
    try {
      String filter = active == 0
          ? "all"
          : active == 1
              ? "pending"
              : "completed";
      SharedPreferences sf = await SharedPreferences.getInstance();
      String accessToken = sf.getString('access_token')!;
      Response res = await get(Uri.parse("$baseUrl/getAllOrders/$filter"),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          });
      if (res.statusCode == 200) {
        orders = jsonDecode(res.body);
        debugPrint(orders.toString());
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
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Orders"),
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
              await getOrders();
            }),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 70,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: modes.length,
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
                              getOrders();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  modes[i],
                                  style: TextStyle(
                                    color: active == i
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
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
                    : orders.isEmpty
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
                                  Text("No Orders Found.")
                                ],
                              ),
                            ),
                          )
                        : const SliverToBoxAdapter(child: SizedBox.shrink()),
            if (orders.isNotEmpty)
              for (var order in orders)
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
                            launchUrl(
                              Uri.parse("tel:${order["order"]["mobile"]}"),
                              mode: LaunchMode.externalApplication,
                            );
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
                                    tag: getCar(order['order']['vehicleType'])
                                        .image,
                                    child: Image.asset(
                                      "assets/${getCar(order['order']['vehicleType']).image}",
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Wrap(
                                    children: [
                                      const Text(
                                        "Name: ",
                                      ),
                                      Text(
                                        "${order['order']['name']}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(),
                                      const Text(
                                        "Source: ",
                                      ),
                                      Text(
                                        "${order['packagee']['source']} ",
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(),
                                      const Text("Destination: "),
                                      Text(
                                        " ${order['packagee']["destination"]}",
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${getCar(order['order']['vehicleType']).title} at RS. ${order['packagee']["price"]} ",
                                      ),
                                      Text(
                                        "Mobile: ${order['order']['mobile']} ",
                                      ),
                                      Text(
                                        "Date: ${order['order']['date']} ",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      child: Icon(
                                        (order['order']['isDone'] == false)
                                            ? CupertinoIcons.check_mark_circled
                                            : CupertinoIcons.info,
                                        color: order['order']['isDone'] == false
                                            ? Colors.green
                                            : Colors.red,
                                        size: 45,
                                      ),
                                      onPressed: () {
                                        showCupertinoDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (context) =>
                                              CupertinoAlertDialog(
                                            title: Text((order['order']
                                                        ['isDone'] ==
                                                    false)
                                                ? "Complete Order"
                                                : "Move back to Pending"),
                                            content: Text(
                                                "Are you sure you want to mark  order from ${order['order']['name']}  as ${(order['order']['isDone'] == false) ? "completed" : "pending"} ?"),
                                            actions: [
                                              CupertinoButton(
                                                child: const Text("No"),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              CupertinoButton(
                                                child: const Text("yes"),
                                                onPressed: () async {
                                                  SharedPreferences sf =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  String accessToken =
                                                      sf.getString(
                                                          'access_token')!;
                                                  Response res = await patch(
                                                      Uri.parse(
                                                          '$baseUrl/updateOrder/${order["order"]["_id"]}'),
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $accessToken',
                                                        'Content-Type':
                                                            'application/json'
                                                      });
                                                  debugPrint(res.statusCode
                                                      .toString());
                                                  debugPrint(
                                                      jsonDecode(res.body)
                                                          .toString());
                                                  if (res.statusCode == 200) {
                                                    showCupertinoDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (context) =>
                                                          CupertinoAlertDialog(
                                                        title: Text(
                                                          (order['order'][
                                                                      'isDone'] ==
                                                                  false)
                                                              ? "moved to completed"
                                                              : "moved to pending",
                                                        ),
                                                        content: Text(
                                                          "Order from ${order["order"]["name"]} moved to ${(order['order']['isDone'] == false) ? "completed" : "pending"} ",
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
                                                              getOrders();
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
                                                          "Order from ${order["order"]["name"]} could not be deleted.",
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
