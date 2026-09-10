import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class ChildHomeView extends StatefulWidget {
  final String childName;
  const ChildHomeView({super.key, required this.childName});

  @override
  State<ChildHomeView> createState() => _ChildHomeViewState();
}

class _ChildHomeViewState extends State<ChildHomeView> {
  @override
  Widget build(BuildContext context) {
    var child = AppData.children.firstWhere(
      (c) => c['name'] == widget.childName,
      orElse: () => AppData.children.first,
    );

    Map<String, dynamic> schedule = child['weeklySchedule'] ?? {};

    int totalTasks = 0;
    int approvedCount = 0;

    schedule.forEach((day, tasks) {
      for (var task in tasks) {
        totalTasks++;
        if (task['approved'] == true) {
          approvedCount++;
        }
      }
    });

    double progress = totalTasks > 0 ? approvedCount / totalTasks : 0.0;
    bool rewardClaimed = child['rewardClaimed'] ?? false;
    bool rewardApproved = child['rewardApproved'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de ${child['name']} 🚀'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade200, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🏆 Meta de Recompensa Dominical',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                      ),
                      Text('Domingo 🎉', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.amber.shade700,
                    minHeight: 14,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Aprobadas por Papá/Mamá: $approvedCount de $totalTasks', style: const TextStyle(fontWeight: FontWeight.w500)),
                      Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                    ],
                  ),
                  if (progress == 1.0) ...[
                    const SizedBox(height: 10),
                    rewardApproved
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              '🎉 ¡Recompensa entregada por Papá/Mamá! Disfrútala.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          )
                        : rewardClaimed
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(8)),
                                child: const Text(
                                  '⏳ Esperando respuesta de Papá/Mamá para entregarte el premio...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                                ),
                              )
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    child['rewardClaimed'] = true;
                                  });
                                },
                                icon: const Icon(Icons.card_giftcard),
                                label: const Text('¡Reclamar Recompensa Dominical!'),
                              ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Selecciona un Día de la Semana:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: schedule.keys.length,
              itemBuilder: (context, index) {
                String dayName = schedule.keys.elementAt(index);
                int dayTasksCount = (schedule[dayName] as List).length;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade100,
                    foregroundColor: Colors.teal.shade900,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DayTasksView(
                          dayName: dayName,
                          tasks: schedule[dayName],
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.teal,
                        child: Text('$dayTasksCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DayTasksView extends StatefulWidget {
  final String dayName;
  final List tasks;

  const DayTasksView({super.key, required this.dayName, required this.tasks});

  @override
  State<DayTasksView> createState() => _DayTasksViewState();
}

class _DayTasksViewState extends State<DayTasksView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas del ${widget.dayName} 📋'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: widget.tasks.isEmpty
          ? const Center(child: Text('No hay tareas programadas para este día.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                bool isCompleted = task['completed'] ?? false;
                bool isApproved = task['approved'] ?? false;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text(
                                isApproved
                                    ? '¡Aprobado por Papá/Mamá! ✅'
                                    : isCompleted
                                        ? 'Esperando aprobación de Papá o Mamá ⏳'
                                        : 'Pendiente de realizar ❌',
                                style: TextStyle(
                                  color: isApproved ? Colors.green : isCompleted ? Colors.orange : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isApproved
                            ? const Chip(label: Text('Aprobado'), backgroundColor: Colors.greenAccent)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCompleted ? Colors.orange.shade100 : Colors.teal,
                                  foregroundColor: isCompleted ? Colors.orange.shade900 : Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    task['completed'] = !isCompleted;
                                  });
                                },
                                child: Text(isCompleted ? 'Desmarcar' : 'Hecho ✓'),
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}