import 'character_model.dart';

class CharacterListModel {
  const CharacterListModel({
    required this.results,
  });

  final List<CharacterModel> results;

  factory CharacterListModel.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? <dynamic>[];

    return CharacterListModel(
      results: rawResults
          .map(
            (item) => CharacterModel.fromJson(
              item as Map<String, dynamic>? ?? <String, dynamic>{},
            ),
          )
          .toList(),
    );
  }
}
