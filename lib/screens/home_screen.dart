import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediation_express/screens/instructions_screen.dart';
import 'package:mediation_express/screens/levels_screen.dart';

import '../widgets/animatedButton_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mediação Express",
          style: GoogleFonts.pressStart2p(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.deepPurple,
            Colors.purpleAccent,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedbuttonWidget(
                context: context,
                label: 'JOGAR',
                targetScreen: const LevelsScreen(),
                color: Colors.purpleAccent,
                icon: Icons.play_arrow,
              ),
              const SizedBox(height: 20),
              AnimatedbuttonWidget(
                context: context,
                label: 'INSTRUÇÕES',
                targetScreen: const InstructionsScreen(),
                color: Colors.purpleAccent,
                icon: Icons.play_arrow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
