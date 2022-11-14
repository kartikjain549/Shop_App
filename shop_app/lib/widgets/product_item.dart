import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../screens/product_screen_detail.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
//  final String id;
  // final String title;
  // final String imageUrl;
//ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authdata = Provider.of<Auth>(context, listen: false);
    return Consumer<Product>(
      builder: (context, value, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            leading: IconButton(
                onPressed: () {
                  product.togglefavoriteStatus(authdata.token, authdata.userId);
                },
                color: Theme.of(context).colorScheme.secondary,
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border)),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:const Text('Item added to the cart!'),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ));
              },
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child:Hero(tag: product.id,
              child: FadeInImage(placeholder:const AssetImage('assets/images/product-placeholder.png'),image:NetworkImage( product.imageUrl,),
              fit: BoxFit.cover,),
            ) 
        ),
      ),
    ));
  }
}
