import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/filme_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // MÉTODO _initDB ATUALIZADO PARA VERSÃO 2 E onUpgrade
  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'filmes.db');

    return await openDatabase(
      path,
      version: 2, // <-- VERSÃO MUDADA PARA 2
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // <-- ADICIONADO MÉTODO DE UPGRADE/RESET
    );
  }

  // MÉTODO DE UPGRADE PARA FORÇAR O RESET/RECRIAÇÃO DA ESTRUTURA
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Se a versão for diferente (ex: subiu de 1 para 2), destrói e recria a tabela.
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE IF EXISTS filmes");
      _onCreate(db, newVersion);
      print(
          '✅ Banco de dados resetado: Tabela filmes recriada na versão $newVersion.');
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE filmes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        url_imagem TEXT,      
        titulo TEXT,
        genero TEXT,
        faixa_etaria TEXT,    
        duracao TEXT,
        pontuacao REAL,
        descricao TEXT,
        ano INTEGER
      )
    ''');
  }

  // --- Operações CRUD (Mantidas as mesmas) ---

  Future<int> insertFilme(Filme filme) async {
    final db = await database;
    return await db.insert('filmes', filme.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Filme>> getFilmes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('filmes', orderBy: 'id DESC');

    return List.generate(maps.length, (i) {
      return Filme.fromMap(maps[i]);
    });
  }

  Future<int> updateFilme(Filme filme) async {
    final db = await database;
    return await db.update(
      'filmes',
      filme.toMap(),
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }

  Future<int> deleteFilme(int id) async {
    final db = await database;
    return await db.delete(
      'filmes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
