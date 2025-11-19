import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme_model.dart';
import '../view_models/filme_list_view_model.dart';
import 'cadastro_filme_view.dart';
import 'detalhes_filme_view.dart';

class ListaFilmesView extends StatefulWidget {
  const ListaFilmesView({super.key});

  @override
  State<ListaFilmesView> createState() => _ListaFilmesViewState();
}

class _ListaFilmesViewState extends State<ListaFilmesView> {
  @override
  void initState() {
    super.initState();
    // Carrega os filmes ao iniciar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FilmeListViewModel>(context, listen: false).loadFilmes();
    });
  }

  void _showTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informações do Grupo'),
          // SUBSTITUIR pelos nomes reais do seu grupo
          content: const Text(
              'Equipe:francisco paulo, paulo henrique, marcos eduardo targino'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsMenu(BuildContext context, Filme filme) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Exibir Dados'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetalhesFilmeView(filme: filme),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Alterar'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CadastroFilmeView(filmeParaEditar: filme),
                    ),
                  );
                  // Recarrega a lista após a edição
                  Provider.of<FilmeListViewModel>(context, listen: false)
                      .loadFilmes();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showTeamDialog(context),
          ),
        ],
      ),
      body: Consumer<FilmeListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.filmes.isEmpty) {
            return const Center(child: Text('Nenhum filme cadastrado.'));
          }
          return ListView.builder(
            itemCount: viewModel.filmes.length,
            itemBuilder: (context, index) {
              final filme = viewModel.filmes[index];
              return Dismissible(
                key: ValueKey(filme.id),
                // Permite arrastar da direita para a esquerda
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  // Pede confirmação antes de deletar
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmação"),
                        content: Text(
                            "Tem certeza que deseja deletar o filme '${filme.titulo}'?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Deletar"),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async {
                  await viewModel.deleteFilme(filme.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${filme.titulo} deletado!')),
                  );
                },
                child: ListTile(
                  leading: SizedBox(
                    width: 70,
                    height: 70,
                    child: filme.urlImagem.isNotEmpty
                        ? Image.network(
                            filme.urlImagem,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.movie, size: 40);
                            },
                          )
                        : const Icon(Icons.movie, size: 40),
                  ),
                  title: Text(filme.titulo),
                  subtitle: RatingBarIndicator(
                    rating: filme.pontuacao,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                  onTap: () => _showOptionsMenu(context, filme),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CadastroFilmeView(),
            ),
          );
          // Recarrega a lista após o cadastro
          Provider.of<FilmeListViewModel>(context, listen: false).loadFilmes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

