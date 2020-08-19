import 'package:flutter/material.dart';
import 'package:noticias_app/models/category.model.dart';
import 'package:noticias_app/services/news_service.dart';
import 'package:noticias_app/theme/tema.dart';
import 'package:noticias_app/widgets/lista_noticias.dart';
import 'package:provider/provider.dart';

class Tab2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final newsService = Provider.of<NewsService>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
              
              _ListaCategoria(),
              Expanded(
                child: ListaNoticias(newsService.getArticulosCategoriaSeleccionada)
              ),
            
            ],
        ),
      ),
    );
  }
}

class _ListaCategoria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<NewsService>(context).categories;
    return Container(
      width: double.infinity,
      height: 80,
      color: Colors.white60,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            final cName = categories[index].name;
            return Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  new _CategoryButton(categories[index]),
                  SizedBox(
                    height: 5,
                  ),
                  Text('${cName[0].toUpperCase()}${cName.substring(1)}')
                ],
              ),
            );
          }),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final Category categoria;

  const _CategoryButton(this.categoria);

  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context);
    return GestureDetector(
      onTap: () {
        /* print(categoria.name); */
        final newsService = Provider.of<NewsService>(context, listen: false);
        newsService.selectedCategory = categoria.name;
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: Icon(
          categoria.icon,
          //si las categorias son iguales sombrea el icono en rojo
          color: (newsService.selectedCategory == this.categoria.name)
              ? miTema.accentColor
              : Colors.black45,
        ),
      ),
    );
  }
}
