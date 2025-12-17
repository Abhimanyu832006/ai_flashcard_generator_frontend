import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:provider/provider.dart';
import 'package:project/widgets/app_background.dart';
import '../../widgets/glass_card.dart';
import '../../providers/flashcard_provider.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final cards = provider.flashcards;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // FIXED: Ensures title is visible on any background
        foregroundColor: colorScheme.onSurface, 
      ),
      body: AppBackground(
        child: cards.isEmpty
            ? _buildEmptyState(context)
            : Column(
                children: [
                  // Spacer for AppBar
                  SizedBox(height: MediaQuery.of(context).padding.top + 60),

                  // Progress Indicator
                  Text(
                    "Card ${_currentIndex + 1} of ${cards.length}",
                    // FIXED: Dynamic color for dark mode
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Flashcard Carousel
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: cards.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: FlipCard(
                            direction: FlipDirection.HORIZONTAL,
                            speed: 700, // POLISH: Slower, premium feel
                            fill: Fill.fillBack, // POLISH: Fixes shadow glitch
                            front: _buildCardSide(
                              context, 
                              title: "QUESTION", 
                              content: card.question, 
                              isFront: true
                            ),
                            back: _buildCardSide(
                              context, 
                              title: "ANSWER", 
                              content: card.answer, 
                              isFront: false
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Navigation Controls
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton.filledTonal(
                          onPressed: _currentIndex > 0
                              ? () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        
                        IconButton.filledTonal(
                          onPressed: _currentIndex < cards.length - 1
                              ? () => _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
      ),
    );
  }

  Widget _buildCardSide(BuildContext context, {required String title, required String content, required bool isFront}) {
    final colorScheme = Theme.of(context).colorScheme;

    // FIXED: Removed inner Container decoration to let GlassCard shine
    return GlassCard(
      // Optional: Pass opacity if your GlassCard widget supports it to differentiate sides
      // opacity: isFront ? 0.15 : 0.18, 
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                // Keep the accent color for distinction
                color: isFront ? colorScheme.onSurface.withOpacity(0.6) : Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    textAlign: TextAlign.center,
                    // FIXED: Dynamic color for dark mode
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (isFront)
              Text(
                "Tap to flip",
                // FIXED: Dynamic color for dark mode
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_outlined, 
            size: 64, 
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
          ),
          const SizedBox(height: 16),
          Text(
            'No flashcards generated yet.',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}