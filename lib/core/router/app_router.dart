import 'package:flutter_application_1/presentation/screens/add_product_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AddProductScreen())
  ],
);
