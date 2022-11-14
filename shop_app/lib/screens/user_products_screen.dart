import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_providers.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/product.dart';
import '../widgets/product_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              },
            ),
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (context, asyncSnapshot) =>
                asyncSnapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: (() => _refreshProducts(context)),
                        child: Consumer<Products>(
                          builder: (context, productsData, _) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: ListView.builder(
                              itemBuilder: (_, i) => UserProductItem(
                                  productsData.items[i].id,
                                  productsData.items[i].title,
                                  productsData.items[i].imageUrl),
                              itemCount: productsData.items.length,
                            ),
                          ),
                        ),
                      )));
  }
}
