import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:noticias_app/models/category.model.dart';
import 'package:noticias_app/models/news_model.dart';
import 'package:http/http.dart' as http;

final _UrlNews = 'https://newsapi.org/v2';
final _APIKEY = 'aae2cf9a057c46329e7dba3870bd5cb2';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.futbol, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];
  //inicializa lista arreglo vacio
  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    //obtiene una categoria de la lista
    categories.forEach((item) {
      this.categoryArticles[item.name] = new List();
    });
  }

  get selectedCategory => this._selectedCategory;
  
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesCategory(valor);
    
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada => this.categoryArticles[this.selectedCategory];

  getTopHeadlines() async {
    print('cargando headlines...');

    final url = '$_UrlNews/top-headlines?apiKey=$_APIKEY&country=us';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesCategory(String category) async {
    //validar si hay duplicados
    if (this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category];
    }

    final url = 
        '$_UrlNews/top-headlines?apiKey=$_APIKEY&country=us&category=$category';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);
    //selecciona la categoria y lo añade en su seccion
    this.categoryArticles[category].addAll(newsResponse.articles);
    notifyListeners();
  }
}
