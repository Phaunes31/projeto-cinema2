class Filme {
  int? id;
  String urlImagem;
  String titulo;
  String genero;
  String faixaEtaria;
  String duracao;
  double pontuacao;
  String descricao;
  int ano;

  Filme({
    this.id,
    required this.urlImagem,
    required this.titulo,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.pontuacao,
    required this.descricao,
    required this.ano,
  });

  // Converte o objeto Filme para um Map (para Sqflite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url_imagem': urlImagem, // CHAVE CORRIGIDA
      'titulo': titulo,
      'genero': genero,
      'faixa_etaria': faixaEtaria, // CHAVE CORRIGIDA
      'duracao': duracao,
      // Garante que o double seja enviado corretamente como REAL
      'pontuacao': pontuacao,
      'descricao': descricao,
      'ano': ano,
    };
  }

  // Cria um objeto Filme a partir de um Map (do Sqflite)
  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      urlImagem: map['url_imagem'] ?? '', // CHAVE CORRIGIDA
      titulo: map['titulo'] ?? '',
      genero: map['genero'] ?? '',
      faixaEtaria: map['faixa_etaria'] ?? '', // CHAVE CORRIGIDA
      duracao: map['duracao'] ?? '',
      // O banco retorna REAL, que é convertido para num, depois para double
      pontuacao: (map['pontuacao'] as num?)?.toDouble() ?? 0.0,
      descricao: map['descricao'] ?? '',
      // Garante que o INTEGER seja lido
      ano: map['ano'] ?? 0,
    );
  }
}
