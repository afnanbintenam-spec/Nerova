import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/vault_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/modern_back_button.dart';
import '../../widgets/modern_input_field.dart';

class KnowledgeVaultScreen extends ConsumerWidget {
  const KnowledgeVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vaultState = ref.watch(vaultProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.mist,
      appBar: AppBar(
        leading: const ModernBackButton(),
        title: Text(
          'Knowledge Vault',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              vaultState.viewMode == 'grid'
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
            ),
            onPressed: () {
              ref
                  .read(vaultProvider.notifier)
                  .setViewMode(vaultState.viewMode == 'grid' ? 'list' : 'grid');
            },
            tooltip: 'Toggle view',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: ModernInputField(
              label: 'Search',
              hint: 'Search notes...',
              prefixIcon: Icons.search_rounded,
              onChanged: (value) {
                ref.read(vaultProvider.notifier).search(value);
              },
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: vaultState.filterType == 'all',
                  onTap: () {
                    ref.read(vaultProvider.notifier).setFilterType('all');
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '✨ AI Summary',
                  isSelected: vaultState.filterType == 'ai_summary',
                  onTap: () {
                    ref
                        .read(vaultProvider.notifier)
                        .setFilterType('ai_summary');
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '❓ Quiz',
                  isSelected: vaultState.filterType == 'ai_quiz',
                  onTap: () {
                    ref.read(vaultProvider.notifier).setFilterType('ai_quiz');
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '🎴 Flashcard',
                  isSelected: vaultState.filterType == 'ai_flashcard',
                  onTap: () {
                    ref
                        .read(vaultProvider.notifier)
                        .setFilterType('ai_flashcard');
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '📝 Notes',
                  isSelected: vaultState.filterType == 'user_note',
                  onTap: () {
                    ref.read(vaultProvider.notifier).setFilterType('user_note');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: vaultState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vaultState.filteredNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 64,
                          color: AppColors.navy.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No notes yet',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  )
                : vaultState.viewMode == 'grid'
                ? GridView.builder(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isSmallScreen ? 1 : 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: vaultState.filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = vaultState.filteredNotes[index];
                      return _NoteCard(
                        note: note,
                        onPin: () {
                          ref.read(vaultProvider.notifier).togglePin(note.id);
                        },
                      );
                    },
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    itemCount: vaultState.filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = vaultState.filteredNotes[index];
                      return _NoteListTile(
                        note: note,
                        onPin: () {
                          ref.read(vaultProvider.notifier).togglePin(note.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.white,
      selectedColor: AppColors.electric.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: isSelected ? AppColors.electric : AppColors.navy,
      ),
      side: BorderSide(
        color: isSelected
            ? AppColors.electric.withValues(alpha: 0.3)
            : Colors.transparent,
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final dynamic note;
  final VoidCallback onPin;

  const _NoteCard({required this.note, required this.onPin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    note.content,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: AppColors.navy.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: note.tags.take(2).map<Widget>((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.electric.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.electric,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                size: 18,
                color: note.isPinned ? AppColors.amber : AppColors.navy,
              ),
              onPressed: onPin,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteListTile extends StatelessWidget {
  final dynamic note;
  final VoidCallback onPin;

  const _NoteListTile({required this.note, required this.onPin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          note.title,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        subtitle: Text(
          note.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: AppColors.navy.withValues(alpha: 0.6),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            size: 18,
            color: note.isPinned ? AppColors.amber : AppColors.navy,
          ),
          onPressed: onPin,
        ),
      ),
    );
  }
}
