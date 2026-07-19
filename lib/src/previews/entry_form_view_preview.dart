import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/entry_form_view.dart';
import 'package:inno_entry/src/previews/entry_dashboard_preview_data.dart';

@Preview(name: 'Entry form - new', size: Size(393, 852))
Widget entryFormNewPreview() {
  return EntryPreviewFrame(
    width: 393,
    height: 852,
    center: false,
    child: _EntryFormPreviewContent(),
  );
}

@Preview(
  name: 'Entry form - dark',
  brightness: Brightness.dark,
  size: Size(393, 852),
)
Widget entryFormDarkPreview() {
  return EntryPreviewFrame(
    brightness: Brightness.dark,
    width: 393,
    height: 852,
    center: false,
    child: _EntryFormPreviewContent(),
  );
}

class _EntryFormPreviewContent extends StatefulWidget {
  @override
  State<_EntryFormPreviewContent> createState() =>
      _EntryFormPreviewContentState();
}

class _EntryFormPreviewContentState extends State<_EntryFormPreviewContent> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  String _selectedCategory = 'Food';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Team lunch');
    _amountController = TextEditingController(text: '48.00');
    _noteController = TextEditingController(
      text:
          'Split the bill with the design team after the Q3 kickoff. Reimburse from team budget.',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EntryFormView(
      mode: EntryFormMode.create,
      todayAmount: 132.20,
      monthAmount: 1247.80,
      categories: entryPreviewCategories,
      selectedCategory: _selectedCategory,
      titleController: _titleController,
      amountController: _amountController,
      noteController: _noteController,
      photoPath: 'preview',
      onTitleChanged: (_) {},
      onAmountChanged: (_) {},
      onNoteChanged: (_) {},
      onUploadPhotoPressed: () {},
      onCategorySelected: (category) {
        setState(() => _selectedCategory = category.name);
      },
      onRemovePhotoPressed: () {},
      onSavePressed: () {},
    );
  }
}
