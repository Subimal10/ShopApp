import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './helpers/custom_route.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Lato',
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CustomPageTransitionBuilder(),
          TargetPlatform.iOS: CustomPageTransitionBuilder(),
        }));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', '', []),
            update: (BuildContext ctx, auth, Products? previous) => Products(
                auth.token,
                auth.userId,
                previous == null ? [] : previous.items),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (BuildContext context, auth, Orders? previous) => Orders(
                auth.token,
                auth.userId,
                previous == null ? [] : previous.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'My Shop',
            theme: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                //primary: Colors.pink,
                secondary: Colors.deepOrange,
              ),
            ),
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (
                      ctx,
                      authResultSnapshot,
                    ) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen()),
            routes: {
              ProductDetailScreen.routeName: (context) =>
                  const ProductDetailScreen(),
              OrderScreen.routeName: (context) => const OrderScreen(),
              CartScreen.routeName: (context) => const CartScreen(),
              UserProductsScreen.routeName: (context) =>
                  const UserProductsScreen(),
              EditProductScreen.routeName: (context) =>
                  const EditProductScreen(),
              AuthScreen.routeName: (context) => const AuthScreen(),
            },
          ),
        ));
  }
}
