import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme_model.dart';
import '../view_models/filme_form_view_model.dart';
import '../utils/faixa_etaria_enum.dart';

class CadastroFilmeView extends StatelessWidget {
  final Filme? filmeParaEditar;
  const CadastroFilmeView({super.key, this.filmeParaEditar});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Cria um novo ViewModel e o inicializa com os dados do filme (se for edição)
      create: (_) => FilmeFormViewModel()..initialize(filmeParaEditar),
      child: Consumer<FilmeFormViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(filmeParaEditar == null
                  ? 'Cadastrar Filme'
                  : 'Alterar Filme'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: viewModel.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: <Widget>[
                    _buildTextFormField(
                      label: 'Url Imagem',
                      initialValue: viewModel.urlImagem,
                      onSaved: viewModel.setUrlImagem,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                      keyboardType: TextInputType.url,
                    ),
                    _buildTextFormField(
                      label: 'Título',
                      initialValue: viewModel.titulo,
                      onSaved: viewModel.setTitulo,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    _buildTextFormField(
                      label: 'Gênero',
                      initialValue: viewModel.genero,
                      onSaved: viewModel.setGenero,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    _buildFaixaEtariaDropdown(viewModel),
                    _buildTextFormField(
                      label: 'Duração (ex: 1h 45min)',
                      initialValue: viewModel.duracao,
                      onSaved: viewModel.setDuracao,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    _buildRatingBar(viewModel),
                    _buildTextFormField(
                      label: 'Ano',
                      initialValue: viewModel.ano,
                      onSaved: viewModel.setAno,
                      validator: (value) =>
                          value!.isEmpty || int.tryParse(value) == null
                              ? 'Ano inválido'
                              : null,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextFormField(
                      label: 'Descrição',
                      initialValue: viewModel.descricao,
                      onSaved: viewModel.setDescricao,
                      validator: (value) =>
                          value!.isEmpty ? 'Campo obrigatório' : null,
                      maxLines: 4, // Aumenta a área de texto da descrição
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: viewModel.isSaving
                  ? null // Desabilita o botão se estiver salvando
                  : () async {
                      if (await viewModel.saveFilme()) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(filmeParaEditar == null
                                ? 'Filme cadastrado com sucesso!'
                                : 'Filme alterado com sucesso!'),
                          ),
                        );
                      } else {
                        // Exibe um erro genérico se o formulário não passou ou falhou no BD
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Erro ao salvar o filme. Verifique o formulário.')),
                        );
                      }
                    },
              label: viewModel.isSaving
                  ? const Row(
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(width: 8),
                        Text('Salvando...'),
                      ],
                    )
                  : Text(filmeParaEditar == null
                      ? 'SALVAR CADASTRO'
                      : 'SALVAR ALTERAÇÃO'),
              icon: const Icon(Icons.save),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  // Widget auxiliar para campos de texto
  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    required void Function(String?) onSaved,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: onSaved,
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }

  // Widget auxiliar para o DropDownButton de Faixa Etária
  Widget _buildFaixaEtariaDropdown(FilmeFormViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Faixa Etária',
          border: OutlineInputBorder(),
        ),
        value: viewModel.faixaEtaria,
        items: FaixaEtaria.valuesAsList
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: viewModel.setFaixaEtaria,
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }

  // Widget auxiliar para o RatingBar
  Widget _buildRatingBar(FilmeFormViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nota:',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          RatingBar.builder(
            initialRating: viewModel.pontuacao,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: viewModel.setPontuacao,
          ),
        ],
      ),
    );
  }
}
