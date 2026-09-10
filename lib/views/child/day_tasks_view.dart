import 'package:flutter/material.dart';

class DayTasksView extends StatefulWidget {
  final String dayName;
  final List<Map<String, dynamic>> tasks;

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
          ? const Center(
              child: Text('No hay tareas programadas para este día.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                bool isCompleted = task['completed'] ?? false;
                bool isApproved = task['approved'] ?? false;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'] ?? '',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
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
                        const SizedBox(width: 10),
                        // Botón de Hecho / Estado
                        isApproved
                            ? const Chip(
                                label: Text('Aprobado'),
                                backgroundColor: Colors.greenAccent,
                              )
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