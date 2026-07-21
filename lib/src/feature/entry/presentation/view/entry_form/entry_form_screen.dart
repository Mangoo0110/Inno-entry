import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inno_entry/src/di/service_locator.dart';
import 'package:inno_entry/src/feature/entry/presentation/bloc/entry_form_bloc.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_form/entry_form_view.dart';
import 'package:path_provider/path_provider.dart';

class EntryFormScreen extends StatefulWidget {
  const EntryFormScreen({
    super.key,
    required this.accountName,
    required this.mode,
    this.entryId,
  });

  final String accountName;
  final EntryFormMode mode;
  final int? entryId;

  @override
  State<EntryFormScreen> createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _noteController = TextEditingController();
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
    return BlocProvider(
      create: (_) => serviceLocator<EntryFormBloc>(
        param1: EntryFormBlocParams(
          accountName: widget.accountName,
          mode: widget.mode,
          entryId: widget.entryId,
        ),
      ),
      child: BlocConsumer<EntryFormBloc, EntryFormState>(
        listenWhen: _shouldListen,
        listener: _onStateChanged,
        buildWhen: _shouldBuild,
        builder: (context, state) {
          if (state.isLoading && state.categories.isEmpty) {
            return const Scaffold(
              body: SafeArea(child: Center(child: CircularProgressIndicator())),
            );
          }

          return EntryFormView(
            mode: state.mode,
            todayAmount: state.todayAmount,
            monthAmount: state.monthAmount,
            categories: state.categories,
            selectedCategory: state.selectedCategory,
            titleController: _titleController,
            amountController: _amountController,
            noteController: _noteController,
            photoPath: state.photoPath,
            isSaving: state.isSubmitting,
            onTitleChanged: (title) {
              context.read<EntryFormBloc>().add(EntryFormTitleChanged(title));
            },
            onAmountChanged: (amount) {
              context.read<EntryFormBloc>().add(EntryFormAmountChanged(amount));
            },
            onNoteChanged: (note) {
              context.read<EntryFormBloc>().add(EntryFormNoteChanged(note));
            },
            onCategorySelected: (category) {
              context.read<EntryFormBloc>().add(
                EntryFormCategorySelected(category),
              );
            },
            onRemovePhotoPressed: () {
              context.read<EntryFormBloc>().add(const EntryFormPhotoRemoved());
            },
            onUploadPhotoPressed: () {
              _pickPhoto(context);
            },
            onSavePressed: () {
              context.read<EntryFormBloc>().add(const EntryFormSubmitted());
            },
          );
        },
      ),
    );
  }

  bool _shouldListen(EntryFormState previous, EntryFormState current) {
    return previous.title != current.title ||
        previous.amount != current.amount ||
        previous.note != current.note ||
        previous.errorMessage != current.errorMessage ||
        previous.saved != current.saved;
  }

  bool _shouldBuild(EntryFormState previous, EntryFormState current) {
    return previous.isLoading != current.isLoading ||
        previous.isSubmitting != current.isSubmitting ||
        previous.categories != current.categories ||
        previous.selectedCategory != current.selectedCategory ||
        previous.photoPath != current.photoPath ||
        previous.todayAmount != current.todayAmount ||
        previous.monthAmount != current.monthAmount;
  }

  void _onStateChanged(BuildContext context, EntryFormState state) {
    _syncController(_titleController, state.title);
    _syncController(_amountController, state.amount);
    _syncController(_noteController, state.note);

    final errorMessage = state.errorMessage;
    if (errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }

    if (state.saved) {
      context.read<EntryFormBloc>().add(const EntryFormSaveHandled());
      context.pop(true);
    }
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _pickPhoto(BuildContext context) async {
    try {
      final pickedPhoto = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedPhoto == null || !context.mounted) return;

      final photoPath = await _persistPickedPhoto(pickedPhoto);
      if (!context.mounted) return;
      context.read<EntryFormBloc>().add(EntryFormPhotoSelected(photoPath));
    } catch (_) {
      if (!context.mounted) return;
      context.read<EntryFormBloc>().add(const EntryFormPhotoUploadRequested());
    }
  }

  Future<String> _persistPickedPhoto(XFile pickedPhoto) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final extension = _fileExtension(pickedPhoto.name);
    final fileName =
        'entry_photo_${DateTime.now().microsecondsSinceEpoch}$extension';
    final savedPhoto = await File(
      pickedPhoto.path,
    ).copy('${appDirectory.path}/$fileName');
    return savedPhoto.path;
  }

  String _fileExtension(String name) {
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == name.length - 1) return '.jpg';
    return name.substring(dotIndex);
  }
}
