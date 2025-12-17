import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flip_card/flip_card.dart';
import '../../widgets/glass_card.dart';
import '../../providers/flashcard_provider.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final cards = provider.flashcards;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Flashcards'),
      ),
      body: cards.isEmpty
          ? const Center(
              child: Text('No flashcards available'),
            )
          : PageView.builder(
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: FlipCard(
                    front: GlassCard(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            card.question,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                    back: GlassCard(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            card.answer,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
