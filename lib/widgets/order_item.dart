import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {super.key});
  final ord.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: _expanded
          ? min(widget.order.products.length * 20.0 + 115, 200.0)
          : 100,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(children: <Widget>[
          ListTile(
            title: Text('\u{20B9}${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 20.0, 140.0)
                : 0,
            child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.title,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${prod.quantity} x \u{20B9}${prod.price}',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    )
                    .toList()),
          )
        ]),
      ),
    );
  }
}
