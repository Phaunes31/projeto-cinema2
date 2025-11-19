import 'package:flutter/foundation.dart';
import '../models/filme_model.dart';
import '../services/database_service.dart';

class FilmeListViewModel extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Filme> filmes = [];
  bool isLoading = false;

  // Carrega todos os filmes do banco de dados
  Future<void> loadFilmes() async {
    isLoading = true;
    notifyListeners();
    filmes = await _dbService.getFilmes();
    isLoading = false;
    notifyListeners();
  }

  // Deleta um filme e atualiza a lista
  Future<void> deleteFilme(int id) async {
    await _dbService.deleteFilme(id);
    // Remove da lista local para atualização rápida da UI
    filmes.removeWhere((filme) => filme.id == id);
    notifyListeners();
  }
}
