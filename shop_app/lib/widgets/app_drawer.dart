import 'package:flutter/material.dart';
import 'package:shop_app/helpers/custom_route.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Hello Friend'),
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.shop),
              title: const Text('Shop'),
              onTap: () {
                // Navigator.of(context).pushReplacementNamed('/');
                Navigator.of(context).pushReplacement(
                    CustomRoute(builder: ((context) => const OrdersScreen())));
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('My Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(UserProductsScreen.routeName);
              }),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              })
        ],
      ),
    );
  }
}