import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        title: 'Accesorios Store',
        theme: ThemeData(
          useMaterial3: false,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF6D6B6B), // Fondo personalizado
            selectedItemColor: Colors.black, // Color del ítem seleccionado
            unselectedItemColor:
                Colors.black, // Color de los ítems no seleccionados
            elevation: 0, // Eliminar sombra
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
