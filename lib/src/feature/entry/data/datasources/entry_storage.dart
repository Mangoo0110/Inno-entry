import 'package:inno_entry/src/feature/entry/data/datasources/interface/entry_datasources.dart';
import 'package:inno_entry/src/feature/entry/data/models/entry_brief_model.dart';
import 'package:inno_entry/src/feature/entry/data/models/entry_model.dart';
import 'package:inno_entry/src/feature/entry/domain/entities/entry_uid.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_all_entry.dart';
import 'package:inno_entry/src/feature/entry/domain/params/delete_entry_param.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entries_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/get_entry_details_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/new_entry_params.dart';
import 'package:inno_entry/src/feature/entry/domain/params/update_entry_params.dart';
import 'package:sqflite/sqflite.dart';

base class EntryStorage implements EntryLocalDatasource {
  // Makes mocking easier and does not affect the real db
  EntryStorage({this.databaseName = 'inno_entry.db'});

  static const _databaseVersion = 1;

  final String databaseName;

  Database? _database;

  @override
  Future<void> init() async {
    if (_database != null) return;

    final databasesPath = await getDatabasesPath();
    final path = _joinPath(databasesPath, databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
    );
  }

  @override
  Future<void> dispose() async {
    final db = _database;
    _database = null;
    await db?.close();
  }

  Database _getDataBase() {
    final database = _database;
    if (database == null) {
      throw StateError('EntryStorage has not been initialized.');
    }
    return database;
  }

  @override
  Future<EntryModel> addNewEntry({required NewEntryParams params}) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final entryId = await _getDataBase().insert(EntryModelFields.tableName, {
      EntryModelFields.owner: params.owner,
      EntryModelFields.title: params.title,
      EntryModelFields.category: params.category,
      EntryModelFields.note: params.note,
      EntryModelFields.amount: params.amount,
      EntryModelFields.photoPath: params.photoPath,
      EntryModelFields.done: params.done ? 1 : 0,
      EntryModelFields.createdAt: now,
      EntryModelFields.updatedAt: now,
    });

    return getEntryDetails(
      params: GetEntryDetailsParams(
        id: EntryUid(uId: entryId),
        owner: params.owner,
      ),
    );
  }

  @override
  Future<void> deleteAllEntry({required DeleteAllEntryParam params}) async {
    await _getDataBase().delete(
      EntryModelFields.tableName,
      where: '${EntryModelFields.owner} = ?',
      whereArgs: [params.owner],
    );
  }

  @override
  Future<void> deleteEntry({required DeleteEntryParam params}) async {
    final deletedCount = await _getDataBase().delete(
      EntryModelFields.tableName,
      where: '${EntryModelFields.id} = ? AND ${EntryModelFields.owner} = ?',
      whereArgs: [params.id.uId, params.owner],
    );

    if (deletedCount == 0) {
      throw Exception('No entry found to delete!');
    }
  }

  @override
  Future<List<EntryBriefModel>> getEntries({
    required GetEntriesParams params,
  }) async {
    final search = params.filters.search.trim().toLowerCase();
    final category = params.filters.category.trim();

    final whereParts = <String>['${EntryModelFields.owner} = ?'];
    final whereArgs = <Object?>[params.owner];

    if (category.isNotEmpty && category.toLowerCase() != 'all') {
      whereParts.add('${EntryModelFields.category} = ?');
      whereArgs.add(category);
    }

    // Avoid a pointless LIKE scan when the user has not typed a search term.
    if (search.isNotEmpty) {
      whereParts.add('LOWER(${EntryModelFields.title}) LIKE ?');
      whereArgs.add('%$search%');
    }

    final rawEntries = await _getDataBase().query(
      EntryModelFields.tableName,
      where: whereParts.join(' AND '),
      whereArgs: whereArgs,
      limit: params.filters.limit,
      offset: (params.filters.page ?? 0) * (params.filters.limit ?? 100),
      orderBy: '${EntryModelFields.updatedAt} DESC',
    );

    return rawEntries.map(EntryBriefModel.fromDb).toList();
  }

  @override
  Future<EntryModel> getEntryDetails({
    required GetEntryDetailsParams params,
  }) async {
    final rawEntries = await _getDataBase().query(
      EntryModelFields.tableName,
      where: '${EntryModelFields.id} = ? AND ${EntryModelFields.owner} = ?',
      whereArgs: [params.id.uId, params.owner],
      limit: 2,
    );

    if (rawEntries.length > 1) {
      throw Exception(
        'Multiple entry found for => id: ${params.id.uId}, owner: ${params.owner}',
      );
    }

    if (rawEntries.isEmpty) {
      throw Exception('No entry found!');
    }

    return EntryModel.fromDb(rawEntries.first);
  }

  @override
  Future<EntryModel> updateEntry({required UpdateEntryParams params}) async {
    final updatedCount = await _getDataBase().update(
      EntryModelFields.tableName,
      {
        if (params.title != null) EntryModelFields.title: params.title,
        if (params.category != null) EntryModelFields.category: params.category,
        if (params.note != null) EntryModelFields.note: params.note,
        if (params.amount != null) EntryModelFields.amount: params.amount,
        if (params.photoPath != null)
          EntryModelFields.photoPath: params.photoPath,
        if (params.done != null) EntryModelFields.done: params.done! ? 1 : 0,
        EntryModelFields.updatedAt: DateTime.now().toUtc().toIso8601String(),
      },
      where: '${EntryModelFields.id} = ? AND ${EntryModelFields.owner} = ?',
      whereArgs: [params.id.uId, params.owner],
    );

    if (updatedCount == 0) {
      throw Exception('No entry found to update!');
    }

    return getEntryDetails(
      params: GetEntryDetailsParams(id: params.id, owner: params.owner),
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // SQLite stores booleans as 0/1 integers, so the CHECK keeps bad values out.
    await db.execute('''
      CREATE TABLE ${EntryModelFields.tableName} (
        ${EntryModelFields.id} INTEGER PRIMARY KEY,
        ${EntryModelFields.owner} TEXT NOT NULL,
        ${EntryModelFields.title} TEXT NOT NULL,
        ${EntryModelFields.note} TEXT NOT NULL,
        ${EntryModelFields.amount} REAL,
        ${EntryModelFields.category} TEXT NOT NULL,
        ${EntryModelFields.done} INTEGER NOT NULL CHECK (${EntryModelFields.done} IN (0, 1)),
        ${EntryModelFields.photoPath} TEXT,
        ${EntryModelFields.createdAt} TEXT NOT NULL,
        ${EntryModelFields.updatedAt} TEXT NOT NULL
      )
    ''');

    // Add indexes for faster row findings.
    // Without an index, SQLite may need to inspect every entry row.
    await db.execute('''
      CREATE INDEX entries_owner_idx
      ON ${EntryModelFields.tableName} (${EntryModelFields.owner})
    ''');

    await db.execute('''
      CREATE INDEX entries_owner_category_idx
      ON ${EntryModelFields.tableName} (
        ${EntryModelFields.owner},
        ${EntryModelFields.category}
      )
    ''');

    await db.execute('''
      CREATE INDEX entries_owner_updated_at_idx
      ON ${EntryModelFields.tableName} (
        ${EntryModelFields.owner},
        ${EntryModelFields.updatedAt}
      )
    ''');
  }

  String _joinPath(String basePath, String childPath) {
    if (basePath.endsWith('/') || basePath.endsWith(r'\')) {
      return '$basePath$childPath';
    }
    return '$basePath/$childPath';
  }
}
