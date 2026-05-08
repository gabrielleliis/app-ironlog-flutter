import 'package:flutter/material.dart';
import '../../viewmodels/workout_viewmodel.dart';
import '../analysis/analysis_view.dart';
import '../auth/login_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final WorkoutViewModel viewModel = WorkoutViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Resumo do Treino', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView())),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.deepPurpleAccent, width: 2),
                  ),
                  child: Column(
                    children: [
                      const Text('Volume Total Levantado (Kg)', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text('${viewModel.totalVolumeMoved} kg', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.bar_chart, color: Colors.white),
                  label: const Text('Análise Muscular', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A2A3C), padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalysisView())),
                ),
                const SizedBox(height: 24),
                const Text('Exercícios de Hoje', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.workouts.length,
                    itemBuilder: (context, index) {
                      final w = viewModel.workouts[index];
                      return Card(
                        color: const Color(0xFF1E1E2C),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            child: const Icon(Icons.fitness_center, color: Colors.white, size: 20),
                          ),
                          title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${w.reps}x repetições • ${w.muscleGroup}'),
                          trailing: Text('${w.weight} kg', style: const TextStyle(fontSize: 16, color: Colors.greenAccent)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
