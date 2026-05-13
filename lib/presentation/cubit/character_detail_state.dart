part of 'character_detail_cubit.dart';

abstract class CharacterDetailState {}

class CharacterDetailInitial extends CharacterDetailState {}

class CharacterDetailLoading extends CharacterDetailState {}

class CharacterDetailSuccess extends CharacterDetailState {
  CharacterDetailSuccess(this.character);

  final Character character;
}

class CharacterDetailError extends CharacterDetailState {
  CharacterDetailError(this.message);

  final String message;
}
