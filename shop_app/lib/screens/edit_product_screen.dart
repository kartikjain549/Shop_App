import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_providers.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import '../providers/product.dart';

class EditProductsScreen extends StatefulWidget {
  const EditProductsScreen({super.key});
  static const routeName = '/edit-products';

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', description: '', price: 0, imageUrl: '');

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var _isInit = true;
    if (_isInit = true) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findbyId(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _isInit = true;
      }
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.png')) {
        return;
      }
      setState(() {});
    }
  }

  Future _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: ((ctx) => AlertDialog(
                title: const Text('An Error Occured!'),
                content: const Text('Something went wrong'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('okay!'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              )),
        );
      }
     // setState(() {
       // _isLoading = false;
     // });
      // ignore: use_build_context_synchronously
    //  Navigator.of(context).pop();
    }
    setState(() {
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return 'Please Provide a Title for Product';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: newValue ?? ' ',
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return 'Please Provide a Price';
                          }
                          if (double.tryParse(newValue) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(newValue) == 0) {
                            return 'Please return a positive no.';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            description: _editedProduct.description,
                            price: double.parse(newValue!),
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        focusNode: _descriptionFocusNode,
                        validator: (newValue) {
                          if (newValue!.isEmpty) {
                            return 'Please Provide a Description';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            id: _editedProduct.id,
                            description: newValue ?? ' ',
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Enter Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (newValue) {
                                if (newValue!.isEmpty) {
                                  return 'Please Provide a valid Url';
                                }
                                if (!newValue.startsWith('http') &&
                                    !newValue.startsWith('https')) {
                                  return 'Please enter a valid Url';
                                }
                                if (!newValue.endsWith('.jpg') &&
                                    !newValue.endsWith('.jpeg') &&
                                    !newValue.endsWith('.png')) {
                                  return 'Please enter a valid Url';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  id: _editedProduct.id,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: newValue ?? '',
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
