import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediation_express/screens/instructions_screen.dart';
import 'package:mediation_express/screens/quiz_screen.dart';

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
              _buildAnimatedButton(
                context: context,
                label: 'JOGAR',
                targetScreen: const QuizScreen(),
                color: Colors.purpleAccent,
                icon: Icons.play_arrow,
              ),
              const SizedBox(height: 20),
              _buildAnimatedButton(
                context: context,
                label: 'INSTRUÇÕES',
                targetScreen: InstructionsScreen(),
                color: Colors.purpleAccent,
                icon: Icons.play_arrow,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required String label,
    required Widget targetScreen,
    required Color color,
    required IconData icon,
  }) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      closedElevation: 6,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      closedColor: color,
      openBuilder: (context, _) => targetScreen,
      closedBuilder: (context, openContainer) => InkWell(
        onTap: openContainer,
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style:
                    GoogleFonts.pressStart2p(fontSize: 14, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
