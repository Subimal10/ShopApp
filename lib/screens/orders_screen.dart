import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndsetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {
            //.....
            //error handling here
            return const Center(
              child: Text('An error occured!'),
            );
          } else {
            return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      itemCount: orderData.orders.length,
                    ));
          }
        },
      ),
    );
  }
}
