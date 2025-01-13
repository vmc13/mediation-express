import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedbuttonWidget extends StatefulWidget {
  final BuildContext context;
  final String label;
  final Widget targetScreen;
  final Color color;
  final IconData icon;
  const AnimatedbuttonWidget(
      {super.key,
      required this.context,
      required this.label,
      required this.targetScreen,
      required this.color,
      required this.icon});

  @override
  State<AnimatedbuttonWidget> createState() => _AnimatedbuttonWidgetState();
}

class _AnimatedbuttonWidgetState extends State<AnimatedbuttonWidget> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      closedElevation: 6,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      closedColor: widget.color,
      openBuilder: (context, _) => widget.targetScreen,
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
                widget.icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
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
