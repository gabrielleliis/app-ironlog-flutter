import '../models/workout_model.dart';

class WorkoutViewModel {
  List<WorkoutModel> workouts = [
    WorkoutModel(id: '1', name: 'Supino Reto', muscleGroup: 'Peito', weight: 80, reps: 10),
    WorkoutModel(id: '2', name: 'Crucifixo', muscleGroup: 'Peito', weight: 20, reps: 12),
    WorkoutModel(id: '3', name: 'Agachamento', muscleGroup: 'Pernas', weight: 100, reps: 8),
    WorkoutModel(id: '4', name: 'Leg Press', muscleGroup: 'Pernas', weight: 200, reps: 10),
    WorkoutModel(id: '5', name: 'Tríceps Polia', muscleGroup: 'Braços', weight: 45, reps: 15),
  ];

  double get totalVolumeMoved {
    return workouts.fold(0, (sum, item) => sum + item.totalVolume);
  }

  Map<String, double> get volumeByMuscle {
    Map<String, double> map = {};
    for (var w in workouts) {
      map[w.muscleGroup] = (map[w.muscleGroup] ?? 0) + w.totalVolume;
    }
    return map;
  }
}
