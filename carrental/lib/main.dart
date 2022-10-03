import 'package:carrental/configs/routes.config.dart' as routes;
import 'package:carrental/view/screens/admin/add_admin.admin.screen.dart';
import 'package:carrental/view/screens/admin/add_package.admin.screen.dart';
import 'package:carrental/view/screens/admin/dashboard.admin.screen.dart';
import 'package:carrental/view/screens/admin/login.admin.screen.dart';
import 'package:carrental/view/screens/admin/orders.admin.screen.dart';
import 'package:carrental/view/screens/admin/profile.admin.screen.dart';
import 'package:carrental/view/screens/choose_car.screen.dart';
import 'package:carrental/view/screens/choose_date.screen.dart';
import 'package:carrental/view/screens/choose_package.screen.dart';
import 'package:carrental/view/screens/user_details.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      initialRoute: routes.chooseCar,
      title: 'Car Rental Nepal',
      theme: const CupertinoThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      routes: {
        routes.chooseCar: (_) => const ChooseCar(),
        routes.chooseDate: (_) => const ChooseDate(),

        // admin
        routes.adminLogin: (_) => const AdminLogin(),
        routes.adminDashboard: (_) => const AdminDashboardScreen(),
        routes.adminAddPackage: (_) => const AddPackageAdmin(),
        routes.adminOrders: (_) => const OrdersScreen(),
        routes.adminProfile: (_) => const AdminProfileScreen(),
        routes.registerAdmin: (_) => const AddAdmin(),
        routes.choosePackage: (_) => const ChoosePackage(),
        routes.userDetails: (_) => const UserDetails(),
      },
    );
  }
}
