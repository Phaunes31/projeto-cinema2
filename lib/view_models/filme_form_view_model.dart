import 'package:flutter/material.dart';
import '../models/filme_model.dart';
import '../services/database_service.dart';
import '../utils/faixa_etaria_enum.dart';

class FilmeFormViewModel extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  final formKey = GlobalKey<FormState>();
  Filme? filme;
  bool isSaving = false;

  // Campos do Formulário (Privados)
  String _urlImagem = '';
  String _titulo = '';
  String _genero = '';
  String _faixaEtaria = FaixaEtaria.livre.displayValue;
  String _duracao = '';
  double _pontuacao = 3.0; // Valor inicial
  String _descricao = '';
  String _ano = '';

  // -------------------------------------------------------------------
  // GETTERS PÚBLICOS (CORREÇÃO: Permitem que a View leia os valores iniciais)
  // -------------------------------------------------------------------
  String get urlImagem => _urlImagem;
  String get titulo => _titulo;
  String get genero => _genero;
  String get faixaEtaria => _faixaEtaria;
  String get duracao => _duracao;
  double get pontuacao => _pontuacao;
  String get descricao => _descricao;
  String get ano => _ano;
  // -------------------------------------------------------------------

  // Inicializa o formulário com dados existentes para edição
  void initialize(Filme? existingFilme) {
    filme = existingFilme;
    if (filme != null) {
      _urlImagem = filme!.urlImagem;
      _titulo = filme!.titulo;
      _genero = filme!.genero;
      _faixaEtaria = filme!.faixaEtaria;
      _duracao = filme!.duracao;
      _pontuacao = filme!.pontuacao;
      _descricao = filme!.descricao;
      _ano = filme!.ano.toString();
    }
    notifyListeners();
  }

  // Métodos onSaved para capturar dados do formulário
  void setUrlImagem(String? value) {
    _urlImagem = value ?? '';
  }

  void setTitulo(String? value) {
    _titulo = value ?? '';
  }

  void setGenero(String? value) {
    _genero = value ?? '';
  }

  void setFaixaEtaria(String? value) {
    if (value != null) {
      _faixaEtaria = value;
      notifyListeners();
    }
  }

  void setDuracao(String? value) {
    _duracao = value ?? '';
  }

  void setPontuacao(double value) {
    _pontuacao = value;
    notifyListeners();
  }

  void setDescricao(String? value) {
    _descricao = value ?? '';
  }

  void setAno(String? value) {
    _ano = value ?? '';
  }

  Future<bool> saveFilme() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      isSaving = true;
      notifyListeners();

      final filmeASalvar = Filme(
        id: filme?.id,
        urlImagem: _urlImagem,
        titulo: _titulo,
        genero: _genero,
        faixaEtaria: _faixaEtaria,
        duracao: _duracao,
        pontuacao: _pontuacao,
        descricao: _descricao,
        ano: int.tryParse(_ano) ?? 0,
      );

      try {
        if (filmeASalvar.id == null) {
          await _dbService.insertFilme(filmeASalvar); // Create
        } else {
          await _dbService.updateFilme(filmeASalvar); // Update
        }
        isSaving = false;
        return true;
      } catch (e) {
        print(e);
        // Lógica de tratamento de erro
        isSaving = false;
        notifyListeners();
        return false;
      }
    }
    return false;
  }
}
