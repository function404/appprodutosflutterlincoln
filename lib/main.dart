import 'package:flutter/material.dart';
import 'models/produto.dart';
import 'screens/lista_produtos.dart';
import 'screens/cadastro_produto.dart';
import 'screens/detalhe_produto.dart';

void main() {
  runApp(const AppProdutos());
}

class AppProdutos extends StatefulWidget {
  const AppProdutos({super.key});

  @override
  State<AppProdutos> createState() => _AppProdutosState();
}

class _AppProdutosState extends State<AppProdutos> {
  bool _modoNoturno = false;

  void _alternarTema() {
    setState(() {
      _modoNoturno = !_modoNoturno;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catálogo de Produtos',
      theme: _modoNoturno 
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.orange, 
                brightness: Brightness.dark,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent, width: 2.0),
                ),
                floatingLabelStyle: TextStyle(color: Colors.orangeAccent),
              ),
            ) 
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                ),
                floatingLabelStyle: TextStyle(color: Colors.orange),
              ),
            ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => ListaProdutosScreen(
                modoNoturno: _modoNoturno,
                aoAlternarTema: _alternarTema,
              ),
            );
          
          case '/cadastro':
            final produto = settings.arguments as Produto?;
            return MaterialPageRoute(builder: (_) => CadastroProdutoScreen(produtoExistente: produto));
          
          case '/detalhes':
            final produto = settings.arguments as Produto;
            return MaterialPageRoute(builder: (_) => DetalheProdutoScreen(produto: produto));
          
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Center(child: Text('Rota não encontrada'))),
            );
        }
      },
    );
  }
}