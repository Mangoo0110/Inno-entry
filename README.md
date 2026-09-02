# InnoEntry

An offline expense tracking and entry recording app. All data stays on the user's device and is not shared with any external provider.


Platforms: Android and iOS. iOS has not been fully tested.


## Tech Stack

- Flutter and Dart
- `flutter_bloc` for presentation state
- `go_router` for routing and auth guards
- `sqflite` for local entry storage
- `flutter_secure_storage` for local account and PIN-related data
- `image_picker` for optional photo attachments
- `RepositoryProvider` and `BlocProvider` for dependency injection
- `json_serializable` for data model mapping helpers

## Build And Run

Install dependencies:

```sh
flutter pub get
```

Regenerate generated files after changing generated models:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Run the app:

```sh
flutter run -d android
```

Run analysis and tests:

```sh
dart analyze
flutter test
```

This is a Flutter app, so use `flutter run` instead of `dart run` to launch the UI.

## Project Structure

The code is organized feature-first so a reviewer can inspect one feature without jumping across unrelated folders.

- `lib/src/app`
  - App routing, auth guard, dashboard shell, theme cubit, and shared app widgets.

- `lib/src/core`
  - Shared theme, constants, response wrappers, error handling, debug helpers, and utilities.

- `lib/src/di`
  - App dependency creation and provider setup.

- `lib/src/feature/auth`
  - Local account creation, login, PIN unlock, secure-storage datasource, repository, use cases, blocs, and UI.

- `lib/src/feature/entry`
  - Entry feed, add/edit form, detail screen, sqflite datasource, repository, use cases, blocs, and UI.

- `lib/src/feature/category`
  - Static category source, category use case, bloc, and category chip widgets.

- `lib/src/previews`
  - Small widget previews for focused UI checks.

## How The App Fits Together

1. `main.dart` creates `AppDependencies`.
2. `AppDependencyScope` exposes repositories, use cases, and app-wide blocs to the widget tree.
3. `AppAuthGuardBloc` watches auth status from local storage.
4. `go_router` uses that auth state to separate guest routes from signed-in routes.
5. `AuthShell` keeps login and register blocs alive across the auth flow.
6. After login, the active account name is passed into dashboard and entry screens.
7. Entry operations receive the active account owner, so local data stays account-scoped.

## Architecture

The app follows a simple layered structure.

Presentation:
- Widgets render state and send user actions to blocs.
- BLoCs own loading, validation, selected filters, pagination, and one-shot UI effects.
- Screen or route-specific blocs are created near the UI scope that owns them.

Domain:
- Use cases describe app actions such as login, create entry, delete entry, and get total amount.
- Params describe use-case input without exposing sqflite row shape.
- Entities represent the data used by the app and UI.

Data:
- Datasources own local storage details.
- Repositories connect use cases with datasources.
- Models own conversion to and from database maps.

Dependency setup:
- `AppDependencies` creates datasources, repositories, use cases, and app-wide blocs.
- `AppDependencyScope` exposes them with providers.
- This keeps dependency setup visible near the app root.

## Main State Owners

- `AppAuthGuardBloc`: auth status for route decisions
- `AppThemeCubit`: runtime theme mode
- `DashboardBloc`: dashboard actions, account menu, logout, delete account, and totals
- `LoginBloc`: account lookup, selected account, PIN input, and unlock state
- `RegisterBloc`: account creation state
- `CategoryChooseBloc`: category loading for chip rows
- `EntryFeedBloc`: feed loading, search, filter, pagination, delete, and undo
- `EntryFormBloc`: add/edit form state, validation, totals, category, save, and photo path
- `EntryDetailBloc`: detail loading, refresh after edit, and delete state

## Feature Walkthrough

Local auth:
- New users can create a local account with a name and PIN.
- Existing users can unlock a local account by name and PIN.
- Logging out clears only the active session reference; the account and entries remain available for later login.
- Deleting the current account removes that account's local entries and auth record without affecting other accounts.

Feed:
- The feed shows only the active account's entries.
- Search and category filters update the list.
- Entries are paginated and can be deleted from the feed.
- Deleted entries can be restored from the undo action.

Add/edit:
- One form handles both new and existing entries.
- The same entry can carry note, task, and expense data.
- Optional photo paths are stored locally.
- Save actions return to the feed and show a confirmation effect.

Entry detail:
- Tapping an entry opens a detail view.
- The detail view can navigate to edit or delete the entry.
## Entry Model

The app uses one entry table for expenses, notes, and tasks. This keeps the local schema small while still supporting the required screens.

Important fields:

- `id`: local primary key
- `owner`: account name used for data scoping
- `title`: display title
- `note`: longer text
- `amount`: optional expense value
- `category`: category name
- `done`: task done or expense paid state
- `photoPath`: optional local image path
- `createdAt` and `updatedAt`: timestamps

An entry with an amount can behave like an expense. An entry without an amount can still work as a note or task.

## Data Decisions

Auth data is stored with secure storage. Entry data is stored with sqflite.

The local datasource uses typed data models instead of raw JSON-like payloads. sqflite rows are maps internally, but model methods own conversion to and from database maps.

Typed models keep the local persistence code easier to inspect and refactor.


## Known Trade-Offs

- Categories are static and come from the category repository implementation.
- The entry table stores the selected category name, not a category relation.
- Theme preference is runtime-only and is not persisted yet.
- iOS is listed as a target but was not fully tested.

## References

- BLoC concepts: https://bloclibrary.dev/cs/flutter-bloc-concepts/
- Infinite list pattern: https://bloclibrary.dev/fr/tutorials/flutter-infinite-list/
