
# Inno_Entry
An offline expense track or recording application.



Platforms:- Android, iOS(Not tested)


## Tech Stack

- Flutter and Dart
- `flutter_bloc` for app, auth, feed, form, and detail state
- `go_router` for routing
- `sqflite` for local entry storage
- `flutter_secure_storage` for local account/PIN data
- `image_picker` for optional local photo attachments
- `get_it` for dependency registration
- `freezed` and `json_serializable` for generated data models

## Build And Run

Install dependencies:

```sh
flutter pub get
```

Regenerate generated files after changing Freezed/JSON models:

```sh
dart run build_runner build --delete-conflicting-outputs
```

Run on iOS:

```sh
flutter run -d ios
```

Run on Android:

```sh
flutter run -d android
```

Run static analysis:

```sh
flutter analyze
```

Run tests:

```sh
flutter test
```

## Project Layout

The code is organized by feature, with shared infrastructure under `core`.

- `lib/src/app`
  - App-level session controller and splash view.
  - `AppAuthUiController` watches the current auth status and exposes app-level actions such as logout and account deletion.

- `lib/src/core`
  - Routing, dependency injection, theme, constants, async response wrappers, error handling, helper utilities, and reusable widgets.

- `lib/src/feature/auth`
  - Local account creation, login, PIN unlock, logout, and account selection.
  - Secure-storage-backed datasource, auth repository, auth use cases, `AuthBloc`, and auth screens/widgets.

- `lib/src/feature/entry`
  - Entry feed, add/edit form, entry detail screen, local persistence, domain entities, params, repositories, and use cases.
  - Feed, form, and detail state are separated into their own BLoCs.

- `lib/src/feature/category`
  - Category entity/model support used by the feed filters and entry form.

- `lib/src/previews`
  - Small widget preview fixtures for focused UI iteration.

## How The App Fits Together

1. `main.dart` configures dependencies, creates `AppAuthUiController`, and starts `MaterialApp.router`.
2. `AuthRouteGate` listens to app auth state and keeps signed-in routes and guest routes separated.
3. Once authenticated, `AuthenticatedAccountRoute` passes the active account name into entry screens.
4. Entry use cases always receive the active account owner, so feed queries and mutations stay account-scoped.
5. Auth data lives in secure storage. Entry data lives in the local sqflite database.
6. UI widgets render BLoC/Cubit state and send user intents back through events or controller methods.

## Entry Model

The app intentionally uses one entry model/table rather than separate models for notes, tasks, and expenses.

Important fields:
- `id`: local primary key
- `owner`: active account name used for account scoping
- `title`: required display title
- `note`: long-form text
- `amount`: optional expense value
- `category`: feed/form category
- `done`: task done or expense paid state
- `photoPath`: optional local image path
- `createdAt` and `updatedAt`: local timestamps

The UI interprets the entry based on populated fields. For example, an entry with an `amount` behaves like an expense, while an entry without one can still work as a note or task.

## State Ownership

Main state owners:

- `AppAuthUiController`
  - Current session/auth status.
  - App-level auth actions such as logout and delete account.

- `AuthBloc`
  - Auth screen flow.
  - Account lookup, account creation, PIN input, unlock state, and auth form errors.

- `EntryFeedBloc`
  - Feed bootstrap, category filters, search, pagination, delete behavior, sync-label source data, and one-shot feed effects.

- `EntryFormBloc`
  - Add/edit form state, field changes, validation, save state, and photo path.

- `EntryDetailBloc`
  - Detail loading, delete state, and detail-level effects.

The intended pattern is that widgets stay thin: they render semantic state and send user actions back to the relevant BLoC or controller. Business decisions and async behavior should stay out of UI widgets.
Used practices:: https://bloclibrary.dev/cs/flutter-bloc-concepts/

https://bloclibrary.dev/fr/tutorials/flutter-infinite-list/

## Feature Walkthrough

Local auth:
- New users can create a local account with a name and PIN.
- Existing users can unlock a local account by name and PIN.
- Logging out clears only the active session reference; the account and entries remain available for later login.
- Deleting the current account removes that account's local entries and auth record without affecting other accounts.

Feed:
- The feed shows the active account's entries only.
- The header includes account context, live balance, and a local freshness label.
- Category filters and search update the list.
- Entries can be paginated and deleted from the feed.

Add/edit:
- One form handles both new and existing entries.
- The same entry can carry note, task, and expense data.
- Optional photo paths are stored locally.
- Save actions return to the feed and emit a single confirmation effect.

Entry detail:
- Tapping an entry opens a detail view.
- The detail view can navigate to edit or delete the entry.

## Data Layer Notes

The local datasource is typed around data models instead of generic map payloads. sqflite rows are still maps internally, but conversion is owned by model methods such as `toDb()` and `fromDb()`.

This keeps the repository and domain layers easier to refactor:
- Datasources handle local persistence details.
- Repositories translate between use-case params and data operations.
- Domain entities and use cases stay independent from sqflite row shape.


Also for theme preference we are not storing this with the shared_preference due to time limit. This is only app runtime state!!



# Trade-Offs

### Data layer trade-off

The local datasource is intentionally typed around app data models instead of raw
JSON-like maps. Although a backend-style service might receive and return generic
payloads, this app is fully offline and uses sqflite directly, where rows are
already represented as `Map<String, Object?>`.

To keep the code safer and easier to refactor, the datasource accepts and returns
data-layer models such as `EntryModel` and `EntryBriefModel`. These models own the
conversion to and from database row maps through `toDb()` and `fromDb()` methods.
The repository remains responsible for translating domain use-case params into
data models before calling the datasource.

### UI + Domain + Data layer trade off
Right now total amount is the total of all the entries with the amount. Which is not right. 
Domain layer should have a clear contract to get this information from the datasource or the source of truth.
Domain layer should return a sum or total with rspond to filters like date, search, categories. And UI or UI-controller or, in this case bloc can decide what type of combination total amount result it wants to show to the user.

Categories are also not stored in or provided from the sqflite database. They are static or hard coded for the moment. However follows architecture decisions and data provided by the repo implementor!
There is a small dependency on the category in the entry feature, showing category chips to select for filtering and entry form. This is now overlooked for the time limitations.
