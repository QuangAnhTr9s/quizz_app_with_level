import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/models/level.dart';
import 'package:quizz_app/services/category_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'level_state.dart';

class LevelCubit extends Cubit<LevelState> {
  LevelCubit() : super(LevelInitial());
  final String doneLevelsKey = 'done_levels';
  Future<void> loadLevels() async {
    emit(LevelLoading());
    List<Level>? levels =
        await CategoryService().loadLevels('assets/data/level.json');
    final prefs = await SharedPreferences.getInstance();

    if (levels.isNotEmpty == true) {
      List<String> doneLevels = prefs.getStringList(doneLevelsKey) ?? [];
      levels = levels.map(
        (e) {
          if (doneLevels.contains(e.level.toString())) {
            e = e.copyWith(isDone: true);
          }
          return e;
        },
      ).toList();
      emit(LevelLoaded(
        levels: levels,
      ));
    } else {
      emit(LevelError());
    }
  }

  Future<void> updateLevel(Level level) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> doneLevels = prefs.getStringList(doneLevelsKey) ?? [];
    if (doneLevels.contains(level.level.toString())) return;
    doneLevels.add(level.level.toString());
    await prefs.setStringList(doneLevelsKey, doneLevels);
  }
}
