import 'package:flutter/material.dart';
import '../../models/app_data.dart';

class ChildHomeView extends StatefulWidget {
  const ChildHomeView({super.key});

  @override
  State<ChildHomeView> createState() => _ChildHomeViewState();
}

class _ChildHomeViewState extends State<ChildHomeView> {
  int _currentIndex = 2; // Inicia en el centro con "Mini Juegos" 🎮

  @override
  Widget build(BuildContext context) {
    var child = AppData.children.isNotEmpty ? AppData.children.first : {'name': 'Niño', 'weeklySchedule': {}};

    final List<Widget> pages = [
      _ChildProfileTab(child: child),
      _ChildRewardsAndWishlistTab(child: child),
      _ChildMiniGamesTab(child: child),
      _ChildLevelTab(child: child),
      _ChildTasksTab(child: child),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.indigo.shade900,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              activeIcon: Icon(Icons.card_giftcard),
              label: 'Recompensas',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.cyan.shade600,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.sports_esports, color: Colors.white, size: 24),
              ),
              label: 'Mini Juegos',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.star_outline),
              activeIcon: Icon(Icons.star),
              label: 'Nivel',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.checklist_rtl_outlined),
              activeIcon: Icon(Icons.checklist_rtl),
              label: 'Mis Tareas',
            ),
          ],
        ),
      ),
    );
  }
}

// 1. PESTAÑA: Perfil del Niño
class _ChildProfileTab extends StatelessWidget {
  final Map<String, dynamic> child;
  const _ChildProfileTab({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A), // Azul oscuro profundo corregido
      appBar: AppBar(
        title: Text('Perfil de ${child['name']} 🌟', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  child['photo'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                  width: 100, height: 100, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100, height: 100, color: Colors.indigo.shade800,
                    child: const Icon(Icons.person, size: 60, color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('¡Hola, ${child['name']}!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              const Text('¡Bienvenido a tu panel de misiones y diversión!', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. PESTAÑA: Recompensas Dominicales + Mis Deseos
class _ChildRewardsAndWishlistTab extends StatelessWidget {
  final Map<String, dynamic> child;
  const _ChildRewardsAndWishlistTab({required this.child});

  @override
  Widget build(BuildContext context) {
    bool rewardClaimed = child['rewardClaimed'] ?? false;
    bool rewardApproved = child['rewardApproved'] ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        title: const Text('Recompensas y Deseos 🎁✨', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            color: Colors.indigo.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.card_giftcard, size: 50, color: Colors.cyanAccent),
                  const SizedBox(height: 10),
                  const Text('Recompensa Dominical 🏆', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('Completa tus misiones de la semana para desbloquear tu premio del domingo.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: rewardApproved ? Colors.green : Colors.cyan.shade700, foregroundColor: Colors.white),
                    onPressed: () {
                      child['rewardClaimed'] = true;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Recompensa reclamada con éxito! 🚀')));
                    },
                    icon: Icon(rewardApproved ? Icons.check_circle : Icons.card_giftcard),
                    label: Text(rewardApproved ? '¡Recompensa Entregada! ✓' : rewardClaimed ? 'Reclamado (Esperando a Papá)' : 'Reclamar Recompensa'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('🌟 Mis Deseos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Card(
            color: Colors.indigo.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.favorite, color: Colors.pinkAccent),
              title: const Text('Juguete o Premio Deseado', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Aún no has agregado deseos', style: TextStyle(color: Colors.white70)),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.cyanAccent),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✨ Próximamente podrás agregar tus deseos aquí')));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. PESTAÑA CENTRAL: Mini Juegos 🎮
class _ChildMiniGamesTab extends StatelessWidget {
  final Map<String, dynamic> child;
  const _ChildMiniGamesTab({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        title: const Text('Zona de Mini Juegos 🕹️', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_esports, size: 90, color: Colors.cyanAccent),
            const SizedBox(height: 16),
            const Text('¡Pronto aquí podrás jugar completando tus retos!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan.shade700, foregroundColor: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎮 ¡Nuevo minijuego en desarrollo para ti!')));
              },
              child: const Text('Jugar Rápido'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. PESTAÑA: Nivel y Experiencia (XP)
class _ChildLevelTab extends StatelessWidget {
  final Map<String, dynamic> child;
  const _ChildLevelTab({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        title: const Text('Tu Nivel y Rango 🌟', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 50, backgroundColor: Colors.cyan.shade700, child: const Icon(Icons.star, size: 50, color: Colors.white)),
              const SizedBox(height: 20),
              const Text('Nivel 1: Explorador del Orden 🛡️', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              const Text('¡Haz más misiones para subir de nivel y ganar medallas legendarias!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

// 5. PESTAÑA: Mis Tareas (Con botones 3D compactos en azul)
class _ChildTasksTab extends StatelessWidget {
  final Map<String, dynamic> child;
  const _ChildTasksTab({required this.child});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> schedule = child['weeklySchedule'] ?? {};
    final List<String> daysOfWeek = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];

    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        title: const Text('Mis Tareas de la Semana 📋', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Selecciona un día para ver tus misiones!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: daysOfWeek.length,
                itemBuilder: (context, index) {
                  String day = daysOfWeek[index];
                  List dayTasks = schedule[day] ?? [];

                  return _Computer3DButton(
                    dayName: day,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _DayTasksDetailView(dayName: day, tasks: dayTasks),
                        ),
                      );
                    },
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

// WIDGET AUXILIAR: Botón 3D Estilo Computadora con temática azul 🖥️👇
class _Computer3DButton extends StatefulWidget {
  final String dayName;
  final VoidCallback onTap;

  const _Computer3DButton({
    required this.dayName,
    required this.onTap,
  });

  @override
  State<_Computer3DButton> createState() => _Computer3DButtonState();
}

class _Computer3DButtonState extends State<_Computer3DButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        transform: Matrix4.translationValues(0.0, _isPressed ? 4.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: Colors.indigo.shade800,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.cyanAccent.shade700, width: 2),
          boxShadow: _isPressed
              ? [
                  const BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 1),
                    blurRadius: 0,
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            widget.dayName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// 6. VISTA SECUNDARIA: Detalle de Tareas de un Día Específico
class _DayTasksDetailView extends StatefulWidget {
  final String dayName;
  final List tasks;
  const _DayTasksDetailView({required this.dayName, required this.tasks});

  @override
  State<_DayTasksDetailView> createState() => _DayTasksDetailViewState();
}

class _DayTasksDetailViewState extends State<_DayTasksDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1A),
      appBar: AppBar(
        title: Text('Misiones del ${widget.dayName} 🎯', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: widget.tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.celebration, size: 70, color: Colors.cyanAccent),
                  const SizedBox(height: 15),
                  Text('¡No hay misiones asignadas para el ${widget.dayName}!', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                var task = widget.tasks[index];
                bool isCompleted = task['completed'] ?? false;
                bool isApproved = task['approved'] ?? false;

                return Card(
                  color: Colors.indigo.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: CheckboxListTile(
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.white38 : Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      isApproved ? '¡Aprobado por Papá! ✅' : isCompleted ? 'Esperando aprobación ⏳' : '¡A por ella! 🚀',
                      style: TextStyle(
                        color: isApproved ? Colors.greenAccent : isCompleted ? Colors.orangeAccent : Colors.cyanAccent,
                        fontSize: 12,
                      ),
                    ),
                    value: isCompleted,
                    activeColor: Colors.cyan.shade700,
                    checkColor: Colors.white,
                    onChanged: isApproved
                        ? null
                        : (bool? value) {
                            setState(() {
                              task['completed'] = value ?? false;
                            });
                          },
                  ),
                );
              },
            ),
    );
  }
}