import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../providers/flashcard_provider.dart';
import '../flashcards/flashcard_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? selectedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'pptx'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Notes')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upload your notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Supported formats: PDF, DOCX, PPTX',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: provider.isLoading ? null : pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Choose File'),
            ),
            const SizedBox(height: 16),

            if (selectedFile != null)
              Text(
                'Selected: ${selectedFile!.name}',
                style: const TextStyle(fontSize: 16),
              ),

            const Spacer(),

            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: selectedFile == null
                    ? null
                    : () async {
                        provider.setLoading(true);
                        provider.setError(null);

                        try {
                          final cards =
                              await ApiService.generateFlashcards(
                                selectedFile!,
                              );
                          provider.setFlashcards(cards);

                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FlashcardScreen(),
                              ),
                            );
                          }
                        } catch (e) {
                          provider.setError(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        } finally {
                          provider.setLoading(false);
                        }
                      },
                child: const Text('Generate Flashcards'),
              ),
          ],
        ),
      ),
    );
  }
}
