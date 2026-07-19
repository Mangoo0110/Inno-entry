import 'package:flutter/material.dart';
import 'package:inno_entry/src/core/theme/app_colors.dart';

class EntryAmountBadge extends StatelessWidget {
  const EntryAmountBadge({
    super.key,
    required this.amount,
    this.currencySymbol = r'$',
  });

  final double amount;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.tileColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              color: colors.primaryColor,
              size: 13,
            ),
            const SizedBox(width: 4),
            Text(
              '$currencySymbol${_formatAmount(amount)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.primaryColor,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double value) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts.first;
    final buffer = StringBuffer();

    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }

    return '${buffer.toString()}.${parts.last}';
  }
}
