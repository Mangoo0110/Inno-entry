# inno_entry

Platforms:- Android, iOS and Web

An offline expense track or recording application.




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