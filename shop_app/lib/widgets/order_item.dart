import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(duration: const Duration(milliseconds: 300),
    height: _expanded? min(
                    widget.order.products.length.toDouble() * 20.0 + 110, 200):95,
      child: Card(
        margin:const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text('\$${widget.order.amount}'),
                subtitle: Text(
                    DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.expand_more,
                  ),
                  onPressed: (() {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  }),
                )),
              AnimatedContainer(duration:const Duration(milliseconds: 300),
                padding:const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                height:_expanded? min(
                    widget.order.products.length.toDouble() * 20.0 + 110, 200):0,
                child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                prod.title.toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text('\$${prod.quantity}x \$${prod.price}')
                            ],
                          ))
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
