import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di/inject_module.dart';
import '../cubit/character_detail_cubit.dart';

class CharacterDetailScreen extends StatelessWidget {
  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  final int characterId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CharacterDetailCubit>()..getCharacter(characterId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Character details'),
        ),
        body: BlocBuilder<CharacterDetailCubit, CharacterDetailState>(
          builder: (context, state) {
            if (state is CharacterDetailInitial ||
                state is CharacterDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CharacterDetailError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        state.message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<CharacterDetailCubit>()
                            .getCharacter(characterId);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final character = (state as CharacterDetailSuccess).character;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    character.image,
                    height: 250,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _infoRow('Status', character.status),
                          _infoRow('Species', character.species),
                          _infoRow('Gender', character.gender),
                          _infoRow('Origin', character.origin.name),
                          _infoRow('Location', character.location.name),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
