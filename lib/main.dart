import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/filme_list_view_model.dart';
import 'views/lista_filmes_view.dart';

void main() {
  // Garante que o Flutter esteja inicializado antes de acessar o BD
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Configura o ViewModel principal para a lista de filmes
      providers: [
        ChangeNotifierProvider(create: (_) => FilmeListViewModel()),
      ],
      child: MaterialApp(
        title: 'Cadastro de Filmes',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Paleta de cores para um visual mais "cinematográfico"
          primarySwatch: Colors.indigo,
          appBarTheme: const AppBarTheme(
            color: Colors.indigo,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          useMaterial3:
              false, // Uso do Material 2 para evitar conflitos de estilo
        ),
        home: const ListaFilmesView(),
      ),
    );
  }
}
