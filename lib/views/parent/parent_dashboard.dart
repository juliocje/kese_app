import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  void _showAddChildDialog() {
    final nameController = TextEditingController();
    final pinController = TextEditingController();
    final photoController = TextEditingController(text: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Nuevo Niño 👦👧'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre del niño')),
              const SizedBox(height: 10),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'PIN Secreto de 4 dígitos (Ej. 1234)'),
              ),
              const SizedBox(height: 10),
              TextField(controller: photoController, decoration: const InputDecoration(labelText: 'URL de la foto de perfil')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                if (nameController.text.isNotEmpty && pinController.text.length == 4) {
                  setState(() {
                    AppData.children.add({
                      'name': nameController.text,
                      'pin': pinController.text,
                      'photo': photoController.text.isNotEmpty ? photoController.text : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                      'rewardClaimed': false,
                      'rewardApproved': false,
                      'weeklySchedule': {
                        'Lunes': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
                        'Martes': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
                        'Miércoles': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
                        'Jueves': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
                        'Viernes': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
                        'Sábado': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
                        'Domingo': [{'title': 'Recompensa', 'completed': false, 'approved': false}],
                      },
                    });
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El PIN debe ser exactamente de 4 dígitos ❌'), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditChildDialog(int index) {
    var child = AppData.children[index];
    final pinController = TextEditingController(text: child['pin'] ?? '');
    final photoController = TextEditingController(text: child['photo'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar a ${child['name']} ⚙️'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Nuevo PIN de 4 dígitos'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: photoController,
                decoration: const InputDecoration(labelText: 'URL de la nueva foto'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  if (pinController.text.length == 4) {
                    child['pin'] = pinController.text;
                  }
                  if (photoController.text.isNotEmpty) {
                    child['photo'] = photoController.text;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Perfil actualizado con éxito! ✅'), backgroundColor: Colors.green),
                );
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _resetWeeklyCycle() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('🔄 Reiniciar Semana'),
          content: const Text(
            'Se mantendrán todas las tareas personalizadas y agregadas, pero se desmarcarán los checks para iniciar una nueva semana. ¿Deseas continuar?',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  for (var child in AppData.children) {
                    child['rewardClaimed'] = false;
                    child['rewardApproved'] = false;
                    Map<String, dynamic> schedule = child['weeklySchedule'];
                    schedule.forEach((day, tasks) {
                      for (var task in tasks) {
                        task['completed'] = false;
                        task['approved'] = false;
                      }
                    });
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Semana reiniciada conservando tus tareas! 🚀')),
                );
              },
              child: const Text('Sí, reiniciar semana'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Panel de Padres 👨‍👩‍👦'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Botón superior: Agregar Niño
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: _showAddChildDialog,
            icon: const Icon(Icons.person_add, size: 20),
            label: const Text('Agregar Niño'),
          ),
          // Botón superior: Reiniciar Semana
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: _resetWeeklyCycle,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('Reiniciar Semana'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Supervisión de hijos (Progreso y Recompensas):',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: AppData.children.length,
                itemBuilder: (context, index) {
                  var child = AppData.children[index];
                  bool rewardClaimed = child['rewardClaimed'] ?? false;
                  bool rewardApproved = child['rewardApproved'] ?? false;

                  Map<String, dynamic> schedule = child['weeklySchedule'] ?? {};
                  int totalTasks = 0;
                  int approvedCount = 0;
                  schedule.forEach((day, tasks) {
                    for (var task in tasks) {
                      totalTasks++;
                      if (task['approved'] == true) approvedCount++;
                    }
                  });
                  double progress = totalTasks > 0 ? approvedCount / totalTasks : 0.0;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 4, offset: const Offset(0, 2))],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentChildDetailView(childIndex: index),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    child['photo'] ?? '',
                                    width: 45,
                                    height: 45,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 45, height: 45, color: Colors.grey[300],
                                      child: const Icon(Icons.person, size: 25, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        child['name'],
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      InkWell(
                                        onTap: () => _showEditChildDialog(index),
                                        child: const Text(
                                          '⚙️ Editar PIN/Foto',
                                          style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey.shade200,
                              color: progress == 1.0 ? Colors.green : Colors.amber.shade700,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Progreso:', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(height: 12),
                            rewardApproved
                                ? const Text('🎁 Recompensa Entregada', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green))
                                : rewardClaimed
                                    ? const Text('🚨 ¡Reclama Premio!', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red))
                                    : Text('🏆 Meta Dominical', style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParentChildDetailView extends StatefulWidget {
  final int childIndex;
  const ParentChildDetailView({super.key, required this.childIndex});

  @override
  State<ParentChildDetailView> createState() => _ParentChildDetailViewState();
}

class _ParentChildDetailViewState extends State<ParentChildDetailView> {
  void _showAddTaskDialog(String day) {
    final taskController = TextEditingController();
    var child = AppData.children[widget.childIndex];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Añadir tarea para el $day (${child['name']})'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(labelText: 'Descripción de la tarea (ej. Sacar la basura)'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    child['weeklySchedule'][day].add({
                      'title': taskController.text,
                      'completed': false,
                      'approved': false,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var child = AppData.children[widget.childIndex];
    Map<String, dynamic> schedule = child['weeklySchedule'];

    int totalTasks = 0;
    int approvedCount = 0;
    schedule.forEach((day, tasks) {
      for (var task in tasks) {
        totalTasks++;
        if (task['approved'] == true) approvedCount++;
      }
    });
    bool isCompleted100 = totalTasks > 0 && approvedCount == totalTasks;
    bool rewardClaimed = child['rewardClaimed'] ?? false;
    bool rewardApproved = child['rewardApproved'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Revisando a ${child['name']} 📝'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (isCompleted100)
            Card(
              color: Colors.amber.shade50,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.amber.shade400, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '🏆 ¡Meta Dominical al 100% Alcanzada!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rewardClaimed
                          ? '${child['name']} ya presionó el botón para reclamar su recompensa dominical.'
                          : '${child['name']} completó todas sus misiones, pero aún no reclama el premio.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rewardApproved ? Colors.green : Colors.amber.shade700,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: rewardClaimed
                          ? () {
                              setState(() {
                                child['rewardApproved'] = !rewardApproved;
                              });
                            }
                          : null,
                      icon: Icon(rewardApproved ? Icons.check_circle : Icons.card_giftcard),
                      label: Text(rewardApproved ? '¡Recompensa Entregada! ✓' : 'Aprobar y Entregar Recompensa'),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          const Text('Revisión y Gestión de Tareas:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...schedule.keys.map((day) {
            List tasks = schedule[day];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ExpansionTile(
                title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${tasks.length} tareas asignadas'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 28),
                  tooltip: 'Añadir tarea para el $day',
                  onPressed: () => _showAddTaskDialog(day),
                ),
                children: tasks.isEmpty
                    ? [const Padding(padding: EdgeInsets.all(8.0), child: Text('Sin tareas este día'))]
                    : tasks.map((task) {
                        int taskIndex = tasks.indexOf(task);
                        bool isCompleted = task['completed'] ?? false;
                        bool isApproved = task['approved'] ?? false;

                        return ListTile(
                          title: Text(task['title']),
                          subtitle: Text(
                            isApproved ? 'Aprobado ✅' : isCompleted ? 'Listo para revisión ⏳' : 'Pendiente ❌',
                            style: TextStyle(color: isApproved ? Colors.green : isCompleted ? Colors.orange : Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isApproved ? Colors.green : Colors.grey.shade300,
                                  foregroundColor: isApproved ? Colors.white : Colors.black87,
                                ),
                                onPressed: () {
                                  setState(() {
                                    task['approved'] = !isApproved;
                                    if (task['approved']) {
                                      task['completed'] = true;
                                    }
                                  });
                                },
                                child: Text(isApproved ? 'Aprobado ✓' : 'Aprobar'),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                tooltip: 'Eliminar tarea',
                                onPressed: () {
                                  setState(() {
                                    tasks.removeAt(taskIndex);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}