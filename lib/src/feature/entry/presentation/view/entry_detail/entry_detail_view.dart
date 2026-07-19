import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/widgets/entry_detail_app_bar.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/widgets/entry_detail_meta_row.dart';
import 'package:inno_entry/src/feature/entry/presentation/view/entry_detail/widgets/entry_detail_photo.dart';

class EntryDetailView extends StatelessWidget {
  const EntryDetailView({
    super.key,
    required this.entry,
    required this.onEditPressed,
    required this.onDeletePressed,
    this.onBackPressed,
    this.isDeleting = false,
  });

  final Entry entry;
  final VoidCallback? onBackPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            EntryDetailAppBar(
              title: 'Entry',
              isDeleting: isDeleting,
              onBackPressed: onBackPressed,
              onEditPressed: onEditPressed,
              onDeletePressed: onDeletePressed,
            ),
            Divider(height: 1, thickness: 1, color: colors.dividerColor),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EntryDetailPhoto(photoPath: entry.photoPath),
                        const SizedBox(height: 18),
                        EntryDetailMetaRow(entry: entry),
                        const SizedBox(height: 18),
                        Text(
                          entry.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: colors.textColor,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                        ),
                        if (entry.amount != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            '\$${entry.amount!.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                          ),
                        ],
                        if (entry.note.trim().isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            entry.note,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: colors.textColor.withAlpha(230),
                                  height: 1.55,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.visible,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showEntryDetailSnackBar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 18),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        elevation: 0,
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF263031),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        content: Text(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
}
