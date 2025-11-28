import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post_model.dart';

class PlaceholderService {
  final String _baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<bool> simularCreate(String titulo, String descricao) async {
    try {
      final novoPost = Post(title: titulo, body: descricao, userId: 1);
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: jsonEncode(novoPost.toJson()),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> simularUpdate(int id, String titulo, String descricao) async {
    try {
      final postEditado = Post(id: 1, title: titulo, body: descricao, userId: 1);
      final response = await http.put(
        Uri.parse('$_baseUrl/1'), 
        body: jsonEncode(postEditado.toJson()),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> simularDelete(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/1'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}