import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character.dart';
import '../../domain/usecases/get_characters_usecase.dart';

part 'character_list_state.dart';

class CharacterListCubit extends Cubit<CharacterListState> {
  CharacterListCubit(this._getCharactersUseCase)
      : super(CharacterListInitial());

  final GetCharactersUseCase _getCharactersUseCase;

  Future<void> getCharacters() async {
    emit(CharacterListLoading());

    try {
      final characters = await _getCharactersUseCase();
      emit(CharacterListSuccess(characters));
    } catch (error) {
      emit(CharacterListError(error.toString()));
    }
  }
}
