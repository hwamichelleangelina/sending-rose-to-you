import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:roses_app/screens/home.dart';
import './providers/auth.dart';
import 'screens/register.dart';
import 'screens/login.dart';
import 'screens/inbox.dart';
import 'screens/send_message.dart';
import 'screens/send_rose.dart';

void main() {
  Get.testMode = true; // Mode testing aktif
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'TheSeasons',
            primarySwatch: Colors.purple,
            scaffoldBackgroundColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255,54,7,30),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color.fromARGB(255, 255, 212, 212)),
              bodyMedium: TextStyle(color: Color.fromARGB(179, 255, 227, 227)),
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: Colors.purple,
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          title: 'Send Me Roses',
          home: auth.isAuth ? const HomeScreen() : const LoginScreen(),
          routes: {
            '/login': (ctx) => const LoginScreen(),
            '/register': (ctx) => const RegisterScreen(),
            '/inbox': (ctx) => const InboxScreen(),
            '/send-message': (ctx) => const SendMessageScreen(),
            '/send-rose': (ctx) => const SendRoseScreen(),
            '/home': (ctx) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}