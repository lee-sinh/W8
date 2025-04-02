import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:w8_practice/model/pancake.dart';
import 'package:w8_practice/model/pancake_dto.dart';
import 'package:w8_practice/repository/pancake_repository.dart';

class FirebasePancakeRepository extends PancakeRepository {
  static const String baseUrl =
      'https://fir-594bb-default-rtdb.asia-southeast1.firebasedatabase.app/';
  static const String pancakesCollection = "pancakes";
  static const String allPancakesUrl = '$baseUrl/$pancakesCollection.json';

  @override
  Future<Pancake> addPancake(
      {required String color, required double price}) async {
    Uri uri = Uri.parse(allPancakesUrl);

    // Create a new data
    final newPancakeData = {'color': color, 'price': price};
    final http.Response response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newPancakeData),
    );

    // Handle errors
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to add user');
    }

    // Firebase returns the new ID in 'name'
    final newId = json.decode(response.body)['name'];

    // Return created user
    return Pancake(id: newId, color: color, price: price);
  }

  @override
  Future<List<Pancake>> getPancakes() async {
    Uri uri = Uri.parse(allPancakesUrl);
    final http.Response response = await http.get(uri);

    // Handle errors
    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to load');
    }

    // Return all users
    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];
    return data.entries
        .map((entry) => PancakeDto.fromJson(entry.key, entry.value))
        .toList();
  }

  @override
  Future<void> removePancake(String pancakeId) async {
    final Uri uri = Uri.parse('$baseUrl/$pancakesCollection/$pancakeId.json');
    final response = await http.delete(uri);

    if (response.statusCode == HttpStatus.ok) {
      print('pancake deleted successfully!');
      await getPancakes();
    } else {
      throw Exception('Failed to delete pancake');
    }
  }

  @override
  Future<void> updatePancake(Pancake pancake, String id) async {
    final Uri uri = Uri.parse('$baseUrl/$pancakesCollection/$id.json');

    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "color": pancake.color,
        "price": pancake.price,
      }),
    );

    if (response.statusCode == HttpStatus.ok) {
      print('Pancake updated successfully!');
    } else {
      throw Exception('Failed to update pancake');
    }
  }
}
