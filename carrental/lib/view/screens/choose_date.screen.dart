import 'package:carrental/configs/cars.config.dart';
import 'package:carrental/configs/routes.config.dart' as routes;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseDate extends StatefulWidget {
  const ChooseDate({
    super.key,
  });

  @override
  State<ChooseDate> createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final Car car = ModalRoute.of(context)!.settings.arguments as Car;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(car.title)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Hero(
            tag: car.image,
            child: Image.asset('assets/${car.image}'),
          ),
          const Text(
            "Pick a Date",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const Text(
            "Pick the date you want to book it for",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              onDateTimeChanged: (DateTime datee) {
                date = datee;
              },
              minimumDate: DateTime.now(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CupertinoButton.filled(
            child: const Text("Next"),
            onPressed: () {
              Navigator.of(context).pushNamed(routes.choosePackage, arguments: {
                'car': car,
                'date': date,
              });
            },
          ),
        ]),
      ),
    );
  }
}
