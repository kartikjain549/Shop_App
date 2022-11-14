import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import '/screens/splash_screen.dart';
import '/screens/user_products_screen.dart';
import '../screens/product_screen_detail.dart';
import '../screens/cart_screen.dart';
import './providers/product_providers.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import '../helpers/custom_route.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(),
            update: (ctx, auth, previousProducts) => Products(
                auth.token.toString(), previousProducts!.items, auth.userId),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            create: (ctx) => Order(),
            update: (ctx, auth, previousOrders) => Order(
                auth.token, previousOrders!.orders, auth.userId.toString()),
          ),
        ],
        child: Consumer<Auth>(
            builder: ((ctx, auth, _) => MaterialApp(
                    title: 'MyShop',
                    theme: ThemeData(
                      colorScheme:
                          ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                              .copyWith(secondary: Colors.deepOrange),
                      fontFamily: 'Lato',
                      pageTransitionsTheme: PageTransitionsTheme(builders:{
                        TargetPlatform.android:CustomPagetransitionBuilder(),
                      TargetPlatform.iOS:CustomPagetransitionBuilder(),} )
                    ),
                    home: auth.isAuth
                        ? const ProductsOverviewScreen()
                        : FutureBuilder(
                            future: auth.tryAutoLogin(),
                            builder: (context, authresultSnapshot) =>
                                authresultSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? const SplashScreen()
                                    : const AuthScreen(),
                          ),
                    routes: {
                      ProductDetailScreen.routeName: (ctx) =>
                          ProductDetailScreen(),
                      CartScreen.routeName: (ctx) => const CartScreen(),
                      OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                      UserProductsScreen.routeName: (ctx) =>
                          const UserProductsScreen(),
                      EditProductsScreen.routeName: (ctx) =>
                          const EditProductsScreen(),
                    }))));
  }
}
