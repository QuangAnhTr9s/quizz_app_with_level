part of 'level_cubit.dart';

abstract class LevelState extends Equatable {
  final List<Level>? levels;

  const LevelState({
    this.levels,
  });
}

class LevelInitial extends LevelState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LevelLoaded extends LevelState {
  final String? message;

  const LevelLoaded({
    this.message,
    super.levels,
  });

  copyWith({
    String? message,
    List<Level>? levels,
  }) {
    return LevelLoaded(
      message: message ?? this.message,
      levels: levels ?? this.levels,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        message,
        levels,
      ];
}

class LevelLoading extends LevelState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LevelError extends LevelState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
