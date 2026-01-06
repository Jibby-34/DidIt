import 'package:flutter/material.dart';
import '../services/streak_service.dart';
import '../theme/app_theme.dart';

class CreateStreakScreen extends StatefulWidget {
  final StreakService streakService;

  const CreateStreakScreen({super.key, required this.streakService});

  @override
  State<CreateStreakScreen> createState() => _CreateStreakScreenState();
}

class _CreateStreakScreenState extends State<CreateStreakScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Streak'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
            
            // Name input
            TextFormField(
              controller: _nameController,
              autofocus: true,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: const InputDecoration(
                labelText: 'Streak Name',
                hintText: 'e.g., Morning Run',
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Description input (optional)
            TextFormField(
              controller: _descriptionController,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Add details about your goal',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            
            const SizedBox(height: 40),
            
            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _createStreak,
                child: _isCreating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.background,
                          ),
                        ),
                      )
                    : const Text('Create Streak'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createStreak() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCreating = true;
    });

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    await widget.streakService.createStreak(
      name: name,
      description: description.isEmpty ? null : description,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

