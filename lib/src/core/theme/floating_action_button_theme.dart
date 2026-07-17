part of 'app_theme.dart';

class FloatingActionButtonThemes {
  static FloatingActionButtonThemeData lightTheme =
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.light().primaryColor,
        foregroundColor: AppColors.light().buttonContentColor,
        shape: CircleBorder(),
        elevation: 2.0,
        iconSize: AppSizes.mediumIconSize,
      );

  static FloatingActionButtonThemeData darkTheme =
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.dark().primaryColor,
        foregroundColor: AppColors.dark().buttonContentColor,
        shape: CircleBorder(),
        elevation: 2.0,
        iconSize: AppSizes.mediumIconSize,
      );
}
