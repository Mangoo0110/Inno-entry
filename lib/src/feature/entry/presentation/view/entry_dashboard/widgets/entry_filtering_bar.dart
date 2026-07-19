import 'package:flutter/material.dart';

class EntryFilteringBar extends StatelessWidget {
  const EntryFilteringBar({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: isVisible ? 3 : 0,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: isVisible
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: const LinearProgressIndicator(minHeight: 3),
            )
          : const SizedBox.shrink(),
    );
  }
}
