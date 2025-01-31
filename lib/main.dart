import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mediation_express/screens/auth/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mediação Express",
      theme: ThemeData(useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
