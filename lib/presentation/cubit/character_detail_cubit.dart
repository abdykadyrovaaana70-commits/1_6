import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/character.dart';
import '../../domain/usecases/get_character_by_id_usecase.dart';

part 'character_detail_state.dart';

class CharacterDetailCubit extends Cubit<CharacterDetailState> {
  CharacterDetailCubit(this._getCharacterByIdUseCase)
      : super(CharacterDetailInitial());

  final GetCharacterByIdUseCase _getCharacterByIdUseCase;

  Future<void> getCharacter(int id) async {
    emit(CharacterDetailLoading());

    try {
      final character = await _getCharacterByIdUseCase(id);
      emit(CharacterDetailSuccess(character));
    } catch (error) {
      emit(CharacterDetailError(error.toString()));
    }
  }
}
