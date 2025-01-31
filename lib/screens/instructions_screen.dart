import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../widgets/grandient_background.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Instruções',
          style: GoogleFonts.pressStart2p(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Como jogar:',
              style: GoogleFonts.pressStart2p(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            _buildInstructionItem(
              LucideIcons.bookOpen,
              'Você será apresentado a cenários de conflito em sala de aula.',
            ),
            const SizedBox(height: 10),
            _buildInstructionItem(
              LucideIcons.checkCircle,
              'Escolha a melhor solução dentre as opções fornecidas.',
            ),
            const SizedBox(height: 10),
            _buildInstructionItem(
              LucideIcons.star,
              'Cada resposta correta vale 1 ponto.',
            ),
            const SizedBox(height: 10),
            _buildInstructionItem(
              LucideIcons.award,
              'Ao final, você verá sua pontuação e um feedback visual.',
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 30),
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
                label: Text(
                  'Voltar',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style:
                  GoogleFonts.pressStart2p(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
