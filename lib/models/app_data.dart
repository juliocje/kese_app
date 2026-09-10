class AppData {
  static final List<Map<String, dynamic>> children = [
    {
      'name': 'Liam',
      'pin': '1234', // PIN de acceso exclusivo para Liam
      'photo': 'https://images.unsplash.com/photo-1540479859555-17af45c78602?w=150',
      'rewardClaimed': false,
      'rewardApproved': false,
      'weeklySchedule': {
        'Lunes': [
          {'title': 'Tender la cama', 'completed': true, 'approved': true},
          {'title': 'Tomar Vitamina C', 'completed': true, 'approved': true},
        ],
        'Martes': [{'title': 'Tender la cama', 'completed': true, 'approved': true}],
        'Miércoles': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
        'Jueves': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
        'Viernes': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
        'Sábado': [{'title': 'Tender la cama', 'completed': false, 'approved': false}],
        'Domingo': [{'title': 'Descanso y Recompensa', 'completed': false, 'approved': false}],
      },
    },
    {
      'name': 'Sofía',
      'pin': '5678', // PIN de acceso exclusivo para Sofía
      'photo': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      'rewardClaimed': false,
      'rewardApproved': false,
      'weeklySchedule': {
        'Lunes': [
          {'title': 'Clase de pintura', 'completed': true, 'approved': true},
        ],
        'Martes': [{'title': 'Ordenar juguetes', 'completed': false, 'approved': false}],
        'Miércoles': [{'title': 'Ordenar juguetes', 'completed': false, 'approved': false}],
        'Jueves': [{'title': 'Ordenar juguetes', 'completed': false, 'approved': false}],
        'Viernes': [{'title': 'Ordenar juguetes', 'completed': false, 'approved': false}],
        'Sábado': [{'title': 'Ordenar juguetes', 'completed': false, 'approved': false}],
        'Domingo': [{'title': 'Descanso y Recompensa', 'completed': false, 'approved': false}],
      },
    },
  ];

  static final List<Map<String, String>> medications = [
    {'name': 'Vitamina C', 'dose': '1 tableta', 'time': '08:00 AM'},
    {'name': 'Jarabe para la tos', 'dose': '5 ml', 'time': '02:00 PM'},
  ];
}