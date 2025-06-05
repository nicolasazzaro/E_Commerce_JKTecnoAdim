import 'package:flutter_application_1/presentation/screens/add_product_screen.dart';
import 'package:flutter_application_1/presentation/screens/categories_screen.dart';
import 'package:flutter_application_1/presentation/screens/control_pedidos_screen.dart';
import 'package:flutter_application_1/presentation/screens/main_screen.dart';
import 'package:flutter_application_1/presentation/screens/control_stock_screen.dart';
import 'package:flutter_application_1/presentation/screens/home_screen.dart';
import 'package:flutter_application_1/presentation/screens/admin_profile_screen.dart';
import 'package:flutter_application_1/presentation/screens/pedido_detail_screen.dart';

import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/control-stock',
      builder: (context, state) => const ControlStockScreen(),
    ),
    GoRoute(
      path: '/admin-profile',
      builder: (context, state) => const AdminProfileScreen(),
    ),
    GoRoute(
      path: '/control-pedidos', 
      builder: (context, state) =>  ControlPedidosScreen(),
    ),
    GoRoute(
      path: '/pedido-detail',
      builder: (context, state) {
        final pedido = state.extra as Pedido;
        return PedidoDetailScreen(pedido: pedido);
      },
    ),


  ],
);
