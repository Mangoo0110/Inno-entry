import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class UserDashboardAccountMenu extends StatelessWidget {
  const UserDashboardAccountMenu({
    super.key,
    required this.onLogoutPressed,
    required this.onDeleteAccountPressed,
  });

  final VoidCallback onLogoutPressed;
  final VoidCallback onDeleteAccountPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Material(
      color: colors.popupBackgroundColor,
      elevation: 14,
      shadowColor: Colors.black.withAlpha(45),
      borderRadius: BorderRadius.circular(10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 250),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _UserDashboardAccountMenuItem(
                icon: Icons.logout_rounded,
                label: 'Log out',
                color: colors.textColor,
                onPressed: onLogoutPressed,
              ),
              const SizedBox(height: 4),
              _UserDashboardAccountMenuItem(
                icon: Icons.delete_outline_rounded,
                label: 'Delete account',
                color: colors.errorColor,
                onPressed: onDeleteAccountPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserDashboardAccountMenuItem extends StatelessWidget {
  const _UserDashboardAccountMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        height: 46,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
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
