import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteTeamsNotifier extends StateNotifier<Set<String>> {
  FavoriteTeamsNotifier() : super({});

  void toggleTeam(String team) {
    if (state.contains(team)) {
      state = {...state}..remove(team);
    } else {
      state = {...state, team};
    }
  }
}

final favoriteTeamsProvider =
    StateNotifierProvider<FavoriteTeamsNotifier, Set<String>>((ref) {
      return FavoriteTeamsNotifier();
    });
