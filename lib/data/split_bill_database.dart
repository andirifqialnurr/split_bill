import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class SplitBillDatabase {
  SplitBillDatabase({Database? database}) : _database = database;

  Database? _database;

  Future<Database> get instance async {
    final existing = _database;
    if (existing != null) return existing;

    final dbPath = await getDatabasesPath();
    final database = await openDatabase(
      p.join(dbPath, 'split_bill.db'),
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createV1,
    );
    _database = database;
    return database;
  }

  Future<void> close() async {
    final existing = _database;
    if (existing == null) return;
    await existing.close();
    _database = null;
  }

  static Future<void> _createV1(Database db, int version) async {
    await db.execute('''
CREATE TABLE bills (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NULL,
  occurred_at TEXT NOT NULL,
  split_mode TEXT NOT NULL,
  equal_total_amount INTEGER NOT NULL DEFAULT 0,
  tax_type TEXT NOT NULL DEFAULT 'none',
  tax_value INTEGER NOT NULL DEFAULT 0,
  service_type TEXT NOT NULL DEFAULT 'none',
  service_value INTEGER NOT NULL DEFAULT 0,
  discount_type TEXT NOT NULL DEFAULT 'none',
  discount_value INTEGER NOT NULL DEFAULT 0,
  subtotal INTEGER NOT NULL DEFAULT 0,
  tax_amount INTEGER NOT NULL DEFAULT 0,
  service_amount INTEGER NOT NULL DEFAULT 0,
  discount_amount INTEGER NOT NULL DEFAULT 0,
  grand_total INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE participants (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  color_seed INTEGER NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0
)
''');

    await db.execute('''
CREATE TABLE bill_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  total_amount INTEGER NOT NULL DEFAULT 0,
  sort_order INTEGER NOT NULL DEFAULT 0
)
''');

    await db.execute('''
CREATE TABLE item_participants (
  item_id INTEGER NOT NULL REFERENCES bill_items(id) ON DELETE CASCADE,
  participant_id INTEGER NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  share_weight INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (item_id, participant_id)
)
''');

    await db.execute('''
CREATE TABLE custom_shares (
  bill_id INTEGER NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
  participant_id INTEGER NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  amount INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (bill_id, participant_id)
)
''');

    await db.execute('''
CREATE TABLE settlement_results (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER NOT NULL REFERENCES bills(id) ON DELETE CASCADE,
  participant_id INTEGER NOT NULL REFERENCES participants(id) ON DELETE CASCADE,
  base_amount INTEGER NOT NULL DEFAULT 0,
  charges_amount INTEGER NOT NULL DEFAULT 0,
  discount_amount INTEGER NOT NULL DEFAULT 0,
  rounding_amount INTEGER NOT NULL DEFAULT 0,
  amount_due INTEGER NOT NULL DEFAULT 0
)
''');

    await db.execute('CREATE INDEX idx_participants_bill_id ON participants(bill_id)');
    await db.execute('CREATE INDEX idx_bill_items_bill_id ON bill_items(bill_id)');
    await db.execute(
      'CREATE INDEX idx_item_participants_participant_id ON item_participants(participant_id)',
    );
    await db.execute(
      'CREATE INDEX idx_settlement_results_bill_id ON settlement_results(bill_id)',
    );
  }
}
