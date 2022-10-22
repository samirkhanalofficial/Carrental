import 'package:carrental/configs/cars.config.dart';
import 'package:carrental/configs/configs.dart';
import 'package:carrental/configs/routes.config.dart' as routes;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChooseCar extends StatefulWidget {
  const ChooseCar({super.key});

  @override
  State<ChooseCar> createState() => _ChooseCarState();
}

class _ChooseCarState extends State<ChooseCar> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Car Rental App"),
        trailing: CupertinoButton(
          onPressed: () {
            showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Car Rental App"),
                content: SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      const Center(
                        child: Text("Demo Project For Car Rental Service."),
                      ),
                      StatefulBuilder(builder: ((context, setState) {
                        int click = 0;
                        return GestureDetector(
                            onDoubleTap: () {
                              click++;
                              if (click == 3) {
                                click = 0;
                                Navigator.of(context)
                                    .pushNamed(routes.adminLogin);
                              }
                            },
                            child: SizedBox(
                              height: 150,
                              width: 150,
                              child: Hero(
                                tag: 'logo',
                                child: Image.asset(
                                  'assets/logo.png',
                                ),
                              ),
                            ));
                      })),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              try {
                                launchUrl(
                                  Uri.parse(facebookPageId),
                                  mode:
                                      LaunchMode.externalNonBrowserApplication,
                                );
                              } catch (e) {
                                launchUrl(
                                  Uri.parse(
                                      facebook),
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.facebook),
                                Text("facebook"),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              launchUrl(
                                Uri.parse(website),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.public),
                                Text("website"),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  CupertinoButton(
                    child: const Text("close"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            );
          },
          padding: const EdgeInsets.all(0),
          child: const Icon(CupertinoIcons.info),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Text(
              "Choose a Car",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            const Text(
              "Choose the model of car you want to rent for.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            for (Car car in cars)
              Padding(
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
                            .pushNamed(routes.chooseDate, arguments: car);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
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
                            Text(car.title),
                          ],
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
