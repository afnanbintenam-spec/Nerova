import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/mood_provider.dart';
import '../theme/app_theme.dart';

class MoodEntryDialog extends ConsumerStatefulWidget {
  const MoodEntryDialog({super.key});

  @override
  ConsumerState<MoodEntryDialog> createState() => _MoodEntryDialogState();
}

class _MoodEntryDialogState extends ConsumerState<MoodEntryDialog> {
  String _selectedMood = 'neutral';
  int _energy = 3;
  int _stress = 3;
  final _noteController = TextEditingController();
  final _selectedActivities = <String>{};
  bool _isLoading = false;

  final _moodOptions = [
    {'mood': 'happy', 'emoji': '😊', 'color': AppColors.mint},
    {'mood': 'energetic', 'emoji': '⚡', 'color': AppColors.amber},
    {'mood': 'neutral', 'emoji': '😐', 'color': AppColors.navy},
    {'mood': 'tired', 'emoji': '😴', 'color': Color(0xFF708090)},
    {'mood': 'stressed', 'emoji': '😰', 'color': AppColors.rose},
    {'mood': 'sad', 'emoji': '😢', 'color': AppColors.electric},
  ];

  final _activityOptions = [
    'studying',
    'exercising',
    'socializing',
    'working',
    'relaxing',
    'sleeping',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);

    final success = await ref
        .read(moodProvider.notifier)
        .addMood(
          mood: _selectedMood,
          energy: _energy,
          stress: _stress,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          activities: _selectedActivities.toList(),
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Container(
          width: isSmallScreen ? double.infinity : 500,
          padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.mint.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      color: AppColors.mint,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'How are you feeling?',
                      style: GoogleFonts.dmSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Mood selection
              Text(
                'Your Mood',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _moodOptions.map((option) {
                  final isSelected = _selectedMood == option['mood'];
                  return InkWell(
                    onTap: () => setState(
                      () => _selectedMood = option['mood'] as String,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (option['color'] as Color)
                            : (option['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? (option['color'] as Color)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        option['emoji'] as String,
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Energy level
              Text(
                'Energy Level: $_energy/5',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _energy.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: AppColors.amber,
                onChanged: (value) => setState(() => _energy = value.round()),
              ),
              const SizedBox(height: 16),

              // Stress level
              Text(
                'Stress Level: $_stress/5',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _stress.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: AppColors.rose,
                onChanged: (value) => setState(() => _stress = value.round()),
              ),
              const SizedBox(height: 16),

              // Activities
              Text(
                'Activities',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _activityOptions.map((activity) {
                  final isSelected = _selectedActivities.contains(activity);
                  return FilterChip(
                    label: Text(activity),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedActivities.add(activity);
                        } else {
                          _selectedActivities.remove(activity);
                        }
                      });
                    },
                    selectedColor: AppColors.electric.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.electric,
                    labelStyle: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.electric : AppColors.navy,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Write a quick note...',
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Submit button
              FilledButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mint,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Save Mood',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
