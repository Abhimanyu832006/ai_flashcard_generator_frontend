import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:project/services/auth_service.dart';
import 'package:project/widgets/app_background.dart';
import 'package:project/widgets/glass_card.dart';
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
      withData: true, // Needed for web, but works on mobile too
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  void _clearFile() {
    setState(() {
      selectedFile = null;
    });
  }

  Future<void> _generateFlashcards(
      BuildContext context, FlashcardProvider provider) async {
    
    // 1️⃣ SAFETY CHECK: Verify user is logged in
    final token = await AuthService.getToken();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please login first")),
        );
      }
      return;
    }

    // 2️⃣ PROCEED
    provider.setLoading(true);
    provider.setError(null);

    try {
      final cards = await ApiService.generateFlashcards(selectedFile!);
      provider.setFlashcards(cards);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FlashcardScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        provider.setError(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        provider.setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlashcardProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Upload Notes"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- Header ---
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Upload your documents",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Supported formats: PDF, DOCX, PPTX",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                    ),
                    const SizedBox(height: 32),

                    // --- Upload Zone ---
                    if (selectedFile == null)
                      _buildUploadZone(context, provider.isLoading)
                    else
                      _buildFileCard(context),

                    const SizedBox(height: 32),

                    // --- Generate Button ---
                    if (provider.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      FilledButton(
                        onPressed: selectedFile == null
                            ? null
                            : () => _generateFlashcards(context, provider),
                        child: const Text("Generate Flashcards"), // FIXED: Was null
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadZone(BuildContext context, bool isLoading) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: isLoading ? null : pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 40, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              "Tap to browse files",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.description, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedFile!.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  _formatFileSize(selectedFile!.size),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: colorScheme.onSurface.withOpacity(0.6)),
            onPressed: _clearFile,
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}