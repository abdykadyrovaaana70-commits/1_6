part of 'character_list_cubit.dart';

abstract class CharacterListState {}

class CharacterListInitial extends CharacterListState {}

class CharacterListLoading extends CharacterListState {}

class CharacterListSuccess extends CharacterListState {
  CharacterListSuccess(this.characters);

  final List<Character> characters;
}

class CharacterListError extends CharacterListState {
  CharacterListError(this.message);

  final String message;
}
