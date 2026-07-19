import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/category/domain/entities/entry_category.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/widgets/entry_form_app_bar.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/widgets/entry_form_category_picker.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/widgets/entry_form_photo_picker.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/widgets/entry_form_save_bar.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/widgets/entry_form_summary_card.dart';

enum EntryFormMode { create, edit }

class EntryFormView extends StatelessWidget {
  const EntryFormView({
    super.key,
    required this.mode,
    required this.todayAmount,
    required this.monthAmount,
    required this.categories,
    required this.selectedCategory,
    required this.titleController,
    required this.amountController,
    required this.noteController,
    required this.onCategorySelected,
    required this.onSavePressed,
    required this.onTitleChanged,
    required this.onAmountChanged,
    required this.onNoteChanged,
    required this.onUploadPhotoPressed,
    this.photoPath,
    this.onBackPressed,
    this.onRemovePhotoPressed,
    this.isSaving = false,
  });

  final EntryFormMode mode;
  final double todayAmount;
  final double monthAmount;
  final List<EntryCategory> categories;
  final String selectedCategory;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController noteController;
  final ValueChanged<EntryCategory> onCategorySelected;
  final VoidCallback onSavePressed;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onNoteChanged;
  final VoidCallback onUploadPhotoPressed;
  final String? photoPath;
  final VoidCallback? onBackPressed;
  final VoidCallback? onRemovePhotoPressed;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            EntryFormAppBar(title: _title, onBackPressed: onBackPressed),
            Divider(height: 1, thickness: 1, color: colors.dividerColor),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: EntryFormSummaryCard(
                              label: 'Today',
                              amount: todayAmount,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EntryFormSummaryCard(
                              label: 'This Month',
                              amount: monthAmount,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: titleController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: onTitleChanged,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: onAmountChanged,
                        decoration: const InputDecoration(
                          labelText: 'Amount (optional)',
                          prefixText: r'$ ',
                        ),
                      ),
                      const SizedBox(height: 16),
                      EntryFormCategoryPicker(
                        categories: categories,
                        selectedCategory: selectedCategory,
                        onSelected: onCategorySelected,
                      ),
                      const SizedBox(height: 18),
                      EntryFormPhotoPicker(
                        photoPath: photoPath,
                        onUploadPhotoPressed: onUploadPhotoPressed,
                        onRemovePhotoPressed: onRemovePhotoPressed,
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: noteController,
                        minLines: 4,
                        maxLines: 6,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: onNoteChanged,
                        decoration: const InputDecoration(labelText: 'Note'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: EntryFormSaveBar(
        isSaving: isSaving,
        onPressed: onSavePressed,
      ),
    );
  }

  String get _title {
    return switch (mode) {
      EntryFormMode.create => 'New entry',
      EntryFormMode.edit => 'Edit entry',
    };
  }
}
