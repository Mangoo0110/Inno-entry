# Changelog

All notable changes to InnoEntry are documented here.

## Unreleased

### Added

- Added app-level `AppDependencies` and `AppDependencyScope` to expose datasources, repositories, use cases, and app-wide blocs through `RepositoryProvider` / `BlocProvider`.
- Added separate auth presentation blocs for login and registration.
- Added `AppAuthGuardBloc` for app-wide auth routing awareness.
- Added `DashboardBloc` for dashboard shell actions, account menu handling, logout, delete-account flow, and total amount refresh.
- Added `CategoryChooseBloc` for category loading and category chip state.
- Added `GetEntryTotalAmount` use case with date-range params and shortcut constructors for today and this month.
- Added widget previews for entry feed components and photo placeholder comparison.
- Added rectangle stripe painter tests for coordinate behavior.

### Changed

- Moved routing to the app layer so core infrastructure stays less coupled to feature-level presentation details.
- Replaced global `GetIt` lookup usage with provider-based dependency access through the Flutter widget tree.
- Renamed the auth wrapper from screen semantics to `AuthShell`, because it owns the auth route scope rather than a single page.
- Moved auth bloc injection to the auth route shell while keeping auth views responsible for rendering their own bloc state.
- Moved dashboard/account actions out of UI-local state and into `DashboardBloc`.
- Kept entry, category, and auth presentation responsibilities separated across their own blocs.
- Updated infinite-scroll behavior so pagination is triggered by the dashboard scroll controller instead of side effects inside widget `build` methods.
- Updated the feed to fetch another page when loaded content does not fill the viewport.
- Updated README project documentation to match the current architecture.

### Fixed

- Guarded direct navigation to `/auth/login/pin` when no account name has been selected.
- Fixed entry feed pagination for short-content screens where `maxScrollExtent` remains `0.0`.
- Improved rectangle stripe placeholder rendering and coordinate calculations.