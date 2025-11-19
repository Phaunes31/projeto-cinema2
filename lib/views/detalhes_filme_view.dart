import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme_model.dart';

class DetalhesFilmeView extends StatelessWidget {
  final Filme filme;
  const DetalhesFilmeView({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagem do Filme (16:9)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: filme.urlImagem.isNotEmpty
                  ? Image.network(
                      filme.urlImagem,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                              child: Icon(Icons.broken_image, size: 50)),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.movie, size: 50)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Título
                  Text(
                    filme.titulo,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Pontuação
                  RatingBarIndicator(
                    rating: filme.pontuacao,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 25.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(height: 16),

                  // Metadados
                  _buildDetailRow('Gênero', filme.genero),
                  _buildDetailRow('Duração', filme.duracao),
                  _buildDetailRow('Ano', filme.ano.toString()),
                  _buildDetailRow('Faixa Etária', filme.faixaEtaria),
                  const SizedBox(height: 20),

                  // Descrição
                  const Text(
                    'Sinopse:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    filme.descricao,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
