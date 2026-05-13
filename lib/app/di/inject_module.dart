import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/constants/api_constants.dart';
import '../../data/datasources/character_api_service.dart';
import '../../data/datasources/quiz_api_service.dart';
import '../../data/repositories/character_repository_impl.dart';
import '../../data/repositories/quiz_repository_impl.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../../domain/usecases/get_character_by_id_usecase.dart';
import '../../domain/usecases/get_characters_usecase.dart';
import '../../domain/usecases/get_quiz_questions_usecase.dart';
import '../../presentation/cubit/character_detail_cubit.dart';
import '../../presentation/cubit/character_list_cubit.dart';
import '../../presentation/cubit/quiz_cubit.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      ),
    );
  }

  if (!getIt.isRegistered<QuizApiService>()) {
    getIt.registerLazySingleton<QuizApiService>(
      () => QuizApiService(
        Dio(
          BaseOptions(
            baseUrl: ApiConstants.quizBaseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ),
      ),
    );
  }

  if (!getIt.isRegistered<CharacterApiService>()) {
    getIt.registerLazySingleton<CharacterApiService>(
      () => CharacterApiService(getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<CharacterRepository>()) {
    getIt.registerLazySingleton<CharacterRepository>(
      () => CharacterRepositoryImpl(getIt<CharacterApiService>()),
    );
  }

  if (!getIt.isRegistered<QuizRepository>()) {
    getIt.registerLazySingleton<QuizRepository>(
      () => QuizRepositoryImpl(getIt<QuizApiService>()),
    );
  }

  if (!getIt.isRegistered<GetCharactersUseCase>()) {
    getIt.registerLazySingleton<GetCharactersUseCase>(
      () => GetCharactersUseCase(getIt<CharacterRepository>()),
    );
  }

  if (!getIt.isRegistered<GetCharacterByIdUseCase>()) {
    getIt.registerLazySingleton<GetCharacterByIdUseCase>(
      () => GetCharacterByIdUseCase(getIt<CharacterRepository>()),
    );
  }

  if (!getIt.isRegistered<GetQuizQuestionsUseCase>()) {
    getIt.registerLazySingleton<GetQuizQuestionsUseCase>(
      () => GetQuizQuestionsUseCase(getIt<QuizRepository>()),
    );
  }

  if (!getIt.isRegistered<CharacterListCubit>()) {
    getIt.registerFactory<CharacterListCubit>(
      () => CharacterListCubit(getIt<GetCharactersUseCase>()),
    );
  }

  if (!getIt.isRegistered<CharacterDetailCubit>()) {
    getIt.registerFactory<CharacterDetailCubit>(
      () => CharacterDetailCubit(getIt<GetCharacterByIdUseCase>()),
    );
  }

  if (!getIt.isRegistered<QuizCubit>()) {
    getIt.registerFactory<QuizCubit>(
      () => QuizCubit(getIt<GetQuizQuestionsUseCase>()),
    );
  }
}
