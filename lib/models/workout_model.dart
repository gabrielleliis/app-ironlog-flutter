class WorkoutModel {
  final String id;
  final String name;
  final String muscleGroup;
  final double weight;
  final int reps;

  WorkoutModel({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.weight,
    required this.reps,
  });

  double get totalVolume => weight * reps;
}
