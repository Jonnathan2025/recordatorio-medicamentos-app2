import 'package:flutter/material.dart';

void main() {
  runApp(const RecordatorioMedicamentosApp());
}

class RecordatorioMedicamentosApp extends StatelessWidget {
  const RecordatorioMedicamentosApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recordatorio de Medicamentos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class Medicamento {
  final String id;
  final String nombre;
  final String dosis;
  final String frecuencia;
  final List<TimeOfDay> horarios;
  final String notas;
  final DateTime fechaInicio;
  bool tomadoHoy;

  Medicamento({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.frecuencia,
    required this.horarios,
    this.notas = '',
    required this.fechaInicio,
    this.tomadoHoy = false,
  });
}

class RegistroToma {
  final String medicamentoId;
  final DateTime fechaHora;
  final bool tomado;

  RegistroToma({
    required this.medicamentoId,
    required this.fechaHora,
    required this.tomado,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Datos de ejemplo
  List<Medicamento> medicamentos = [
    Medicamento(
      id: '1',
      nombre: 'Aspirina',
      dosis: '100mg',
      frecuencia: 'Cada 8 horas',
      horarios: [
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 16, minute: 0),
        const TimeOfDay(hour: 24, minute: 0),
      ],
      notas: 'Tomar con comida para evitar molestias estomacales',
      fechaInicio: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Medicamento(
      id: '2',
      nombre: 'Metformina',
      dosis: '500mg',
      frecuencia: 'Cada 12 horas',
      horarios: [
        const TimeOfDay(hour: 9, minute: 0),
        const TimeOfDay(hour: 21, minute: 0),
      ],
      notas: 'Antes del desayuno y cena',
      fechaInicio: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Medicamento(
      id: '3',
      nombre: 'Lisinopril',
      dosis: '10mg',
      frecuencia: 'Una vez al día',
      horarios: [
        const TimeOfDay(hour: 7, minute: 30),
      ],
      notas: 'Para control de presión arterial',
      fechaInicio: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<RegistroToma> historial = [];

  @override
  void initState() {
    super.initState();
    _generarHistorialEjemplo();
  }

  void _generarHistorialEjemplo() {
    // Generar historial de ejemplo de los últimos 7 días
    for (int i = 0; i < 7; i++) {
      DateTime fecha = DateTime.now().subtract(Duration(days: i));
      for (var medicamento in medicamentos) {
        for (var horario in medicamento.horarios) {
          historial.add(RegistroToma(
            medicamentoId: medicamento.id,
            fechaHora: DateTime(fecha.year, fecha.month, fecha.day, horario.hour, horario.minute),
            tomado: i < 5, // Los últimos 5 días tomados
          ));
        }
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildHomeTab(),
      _buildMedicamentosTab(),
      _buildHistorialTab(),
      _buildPerfilTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForIndex(_selectedIndex)),
        centerTitle: true,
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication, size: 28),
            label: 'Medicamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 28),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
        onPressed: _agregarMedicamento,
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0: return 'Recordatorios de Hoy';
      case 1: return 'Mis Medicamentos';
      case 2: return 'Historial';
      case 3: return 'Mi Perfil';
      default: return 'Recordatorio Medicamentos';
    }
  }

  Widget _buildHomeTab() {
    DateTime now = DateTime.now();
    List<Widget> proximasTomas = [];

    for (var medicamento in medicamentos) {
      for (var horario in medicamento.horarios) {
        DateTime proximaToma = DateTime(now.year, now.month, now.day, horario.hour, horario.minute);
        if (proximaToma.isAfter(now)) {
          proximasTomas.add(_buildProximaTomaCard(medicamento, horario, proximaToma));
        }
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBienvenidaCard(),
          const SizedBox(height: 20),
          _buildResumenDiario(),
          const SizedBox(height: 20),
          Text(
            'Próximas Tomas',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          if (proximasTomas.isEmpty)
            _buildEmptyState('No hay más tomas programadas para hoy', Icons.check_circle_outline)
          else
            ...proximasTomas,
        ],
      ),
    );
  }

  Widget _buildBienvenidaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Buen día!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Recuerda tomar tus medicamentos a tiempo',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medication,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenDiario() {
    int totalTomas = 0;
    int tomasCompletas = 0;

    for (var medicamento in medicamentos) {
      totalTomas += medicamento.horarios.length;
      if (medicamento.tomadoHoy) tomasCompletas++;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen de Hoy',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(tomasCompletas / totalTomas * 100).round()}%',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildEstadisticaCard(
                  'Completadas',
                  '$tomasCompletas',
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEstadisticaCard(
                  'Pendientes',
                  '${totalTomas - tomasCompletas}',
                  Colors.orange,
                  Icons.schedule,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEstadisticaCard(
                  'Total',
                  '$totalTomas',
                  Colors.blue,
                  Icons.medication,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticaCard(String titulo, String valor, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProximaTomaCard(Medicamento medicamento, TimeOfDay horario, DateTime proximaToma) {
    Duration diferencia = proximaToma.difference(DateTime.now());
    String tiempoRestante = diferencia.inHours > 0
        ? '${diferencia.inHours}h ${diferencia.inMinutes % 60}m'
        : '${diferencia.inMinutes}m';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.access_time,
              color: Colors.blue[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicamento.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${medicamento.dosis} - ${horario.format(context)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'En $tiempoRestante',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _marcarComoTomado(medicamento),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Tomado', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicamentosTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (medicamentos.isEmpty)
            _buildEmptyState('No tienes medicamentos registrados', Icons.medication)
          else
            ...medicamentos.map((medicamento) => _buildMedicamentoCard(medicamento)),
        ],
      ),
    );
  }

  Widget _buildMedicamentoCard(Medicamento medicamento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicamento.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${medicamento.dosis} - ${medicamento.frecuencia}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'editar') {
                    _editarMedicamento(medicamento);
                  } else if (value == 'eliminar') {
                    _eliminarMedicamento(medicamento);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Horarios:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: medicamento.horarios.map((horario) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                horario.format(context),
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
          if (medicamento.notas.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Notas:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              medicamento.notas,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistorialTab() {
    Map<String, List<RegistroToma>> historialPorFecha = {};

    for (var registro in historial) {
      String fecha = '${registro.fechaHora.day}/${registro.fechaHora.month}/${registro.fechaHora.year}';
      if (!historialPorFecha.containsKey(fecha)) {
        historialPorFecha[fecha] = [];
      }
      historialPorFecha[fecha]!.add(registro);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEstadisticasHistorial(),
          const SizedBox(height: 20),
          if (historialPorFecha.isEmpty)
            _buildEmptyState('No hay historial disponible', Icons.history)
          else
            ...historialPorFecha.entries.map((entry) => _buildHistorialFecha(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildEstadisticasHistorial() {
    int totalRegistros = historial.length;
    int tomados = historial.where((r) => r.tomado).length;
    double porcentaje = totalRegistros > 0 ? (tomados / totalRegistros * 100) : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estadísticas de los últimos 7 días',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${porcentaje.round()}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                    const Text('Adherencia', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$tomados',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text('Tomados', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${totalRegistros - tomados}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Text('Perdidos', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialFecha(String fecha, List<RegistroToma> registros) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fecha,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...registros.map((registro) {
            Medicamento? medicamento = medicamentos.firstWhere(
                  (m) => m.id == registro.medicamentoId,
              orElse: () => Medicamento(
                id: '',
                nombre: 'Medicamento eliminado',
                dosis: '',
                frecuencia: '',
                horarios: [],
                fechaInicio: DateTime.now(),
              ),
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    registro.tomado ? Icons.check_circle : Icons.cancel,
                    color: registro.tomado ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${medicamento.nombre} - ${TimeOfDay.fromDateTime(registro.fechaHora).format(context)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    registro.tomado ? 'Tomado' : 'Perdido',
                    style: TextStyle(
                      fontSize: 12,
                      color: registro.tomado ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPerfilTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerfilHeader(),
          const SizedBox(height: 20),
          _buildConfiguracionCard(),
          const SizedBox(height: 16),
          _buildInformacionCard(),
        ],
      ),
    );
  }

  Widget _buildPerfilHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue[100],
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'María González',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Edad: 68 años',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Usando la app desde hace 15 días',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfiguracionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuración',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildConfigOption(Icons.notifications, 'Notificaciones', true),
          _buildConfigOption(Icons.volume_up, 'Sonido de alarma', true),
          _buildConfigOption(Icons.vibration, 'Vibración', false),
          _buildConfigOption(Icons.dark_mode, 'Modo oscuro', false),
        ],
      ),
    );
  }

  Widget _buildConfigOption(IconData icon, String titulo, bool valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Switch(
            value: valor,
            onChanged: (newValue) {
              // Aquí iría la lógica para cambiar la configuración
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$titulo ${newValue ? 'activado' : 'desactivado'}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            activeColor: Colors.blue[700],
          ),
        ],
      ),
    );
  }

  Widget _buildInformacionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoOption(Icons.help_outline, 'Ayuda y soporte', () {
            _mostrarAyuda();
          }),
          _buildInfoOption(Icons.info_outline, 'Acerca de la app', () {
            _mostrarAcercaDe();
          }),
          _buildInfoOption(Icons.privacy_tip_outlined, 'Política de privacidad', () {
            _mostrarPoliticaPrivacidad();
          }),
          _buildInfoOption(Icons.logout, 'Cerrar sesión', () {
            _cerrarSesion();
          }),
        ],
      ),
    );
  }

  Widget _buildInfoOption(IconData icon, String titulo, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                titulo,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String mensaje, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            mensaje,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _marcarComoTomado(Medicamento medicamento) {
    setState(() {
      medicamento.tomadoHoy = true;
    });

    // Agregar al historial
    historial.add(RegistroToma(
      medicamentoId: medicamento.id,
      fechaHora: DateTime.now(),
      tomado: true,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${medicamento.nombre} marcado como tomado'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _agregarMedicamento() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgregarMedicamentoScreen(
          onMedicamentoAgregado: (medicamento) {
            setState(() {
              medicamentos.add(medicamento);
            });
          },
        ),
      ),
    );
  }

  void _editarMedicamento(Medicamento medicamento) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditarMedicamentoScreen(
          medicamento: medicamento,
          onMedicamentoEditado: (medicamentoEditado) {
            setState(() {
              int index = medicamentos.indexWhere((m) => m.id == medicamento.id);
              if (index != -1) {
                medicamentos[index] = medicamentoEditado;
              }
            });
          },
        ),
      ),
    );
  }

  void _eliminarMedicamento(Medicamento medicamento) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Medicamento'),
        content: Text('¿Estás seguro de que deseas eliminar ${medicamento.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                medicamentos.removeWhere((m) => m.id == medicamento.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${medicamento.nombre} eliminado'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _mostrarAyuda() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda y Soporte'),
        content: const Text(
            'Esta aplicación te ayuda a recordar tomar tus medicamentos a tiempo.\n\n'
                '• Agrega tus medicamentos con horarios específicos\n'
                '• Recibe notificaciones para cada toma\n'
                '• Lleva un registro de tu adherencia\n\n'
                'Para más ayuda, contacta a: soporte@medicamentos.app'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _mostrarAcercaDe() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de la App'),
        content: const Text(
            'Recordatorio de Medicamentos v1.0\n\n'
                'Desarrollado como parte del proyecto de tesis:\n'
                '"Diseño e Implementación de una Aplicación móvil para la gestión de medicación y recordatorios en adultos mayores"\n\n'
                'Universidad: [Tu Universidad]\n'
                'Autor: [Tu Nombre]\n'
                'Año: 2025'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarPoliticaPrivacidad() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const Text(
            'Tu privacidad es importante para nosotros.\n\n'
                '• Los datos se almacenan localmente en tu dispositivo\n'
                '• No compartimos información personal con terceros\n'
                '• Puedes eliminar todos tus datos en cualquier momento\n\n'
                'Esta aplicación es un prototipo académico desarrollado con fines educativos.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}

// Pantalla para agregar nuevo medicamento
class AgregarMedicamentoScreen extends StatefulWidget {
  final Function(Medicamento) onMedicamentoAgregado;

  const AgregarMedicamentoScreen({
    Key? key,
    required this.onMedicamentoAgregado,
  }) : super(key: key);

  @override
  State<AgregarMedicamentoScreen> createState() => _AgregarMedicamentoScreenState();
}

class _AgregarMedicamentoScreenState extends State<AgregarMedicamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _dosisController = TextEditingController();
  final _notasController = TextEditingController();

  String _frecuenciaSeleccionada = 'Una vez al día';
  List<TimeOfDay> _horarios = [const TimeOfDay(hour: 8, minute: 0)];

  final List<String> _frecuencias = [
    'Una vez al día',
    'Cada 8 horas',
    'Cada 12 horas',
    'Dos veces al día',
    'Tres veces al día',
    'Personalizado',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Medicamento'),
        actions: [
          TextButton(
            onPressed: _guardarMedicamento,
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSeccionTitulo('Información del Medicamento'),
              const SizedBox(height: 16),
              _buildCampoTexto(
                controller: _nombreController,
                label: 'Nombre del medicamento',
                icon: Icons.medication,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa el nombre del medicamento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildCampoTexto(
                controller: _dosisController,
                label: 'Dosis (ej: 500mg, 1 tableta)',
                icon: Icons.straighten,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa la dosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildSeccionTitulo('Frecuencia'),
              const SizedBox(height: 16),
              _buildSelectorFrecuencia(),
              const SizedBox(height: 24),
              _buildSeccionTitulo('Horarios'),
              const SizedBox(height: 16),
              _buildSelectorHorarios(),
              const SizedBox(height: 24),
              _buildSeccionTitulo('Notas (Opcional)'),
              const SizedBox(height: 16),
              _buildCampoTexto(
                controller: _notasController,
                label: 'Instrucciones especiales',
                icon: Icons.note,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildSelectorFrecuencia() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _frecuenciaSeleccionada,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue[700]),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          onChanged: (String? newValue) {
            setState(() {
              _frecuenciaSeleccionada = newValue!;
              _actualizarHorarios();
            });
          },
          items: _frecuencias.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSelectorHorarios() {
    return Column(
      children: [
        ..._horarios.asMap().entries.map((entry) {
          int index = entry.key;
          TimeOfDay horario = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue[700]),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Horario ${index + 1}: ${horario.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                  onPressed: () => _seleccionarHorario(index),
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                if (_horarios.length > 1)
                  IconButton(
                    onPressed: () => _eliminarHorario(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
          );
        }),
        if (_frecuenciaSeleccionada == 'Personalizado')
          ElevatedButton.icon(
            onPressed: _agregarHorario,
            icon: const Icon(Icons.add),
            label: const Text('Agregar Horario'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
      ],
    );
  }

  void _actualizarHorarios() {
    switch (_frecuenciaSeleccionada) {
      case 'Una vez al día':
        _horarios = [const TimeOfDay(hour: 8, minute: 0)];
        break;
      case 'Dos veces al día':
        _horarios = [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 20, minute: 0),
        ];
        break;
      case 'Tres veces al día':
        _horarios = [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 14, minute: 0),
          const TimeOfDay(hour: 20, minute: 0),
        ];
        break;
      case 'Cada 8 horas':
        _horarios = [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 16, minute: 0),
          const TimeOfDay(hour: 24, minute: 0),
        ];
        break;
      case 'Cada 12 horas':
        _horarios = [
          const TimeOfDay(hour: 8, minute: 0),
          const TimeOfDay(hour: 20, minute: 0),
        ];
        break;
    }
  }

  void _seleccionarHorario(int index) async {
    TimeOfDay? nuevoHorario = await showTimePicker(
      context: context,
      initialTime: _horarios[index],
    );

    if (nuevoHorario != null) {
      setState(() {
        _horarios[index] = nuevoHorario;
      });
    }
  }

  void _agregarHorario() async {
    TimeOfDay? nuevoHorario = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );

    if (nuevoHorario != null) {
      setState(() {
        _horarios.add(nuevoHorario);
      });
    }
  }

  void _eliminarHorario(int index) {
    setState(() {
      _horarios.removeAt(index);
    });
  }

  void _guardarMedicamento() {
    if (_formKey.currentState!.validate()) {
      final nuevoMedicamento = Medicamento(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text,
        dosis: _dosisController.text,
        frecuencia: _frecuenciaSeleccionada,
        horarios: _horarios,
        notas: _notasController.text,
        fechaInicio: DateTime.now(),
      );

      widget.onMedicamentoAgregado(nuevoMedicamento);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${nuevoMedicamento.nombre} agregado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

// Pantalla para editar medicamento existente
class EditarMedicamentoScreen extends StatefulWidget {
  final Medicamento medicamento;
  final Function(Medicamento) onMedicamentoEditado;

  const EditarMedicamentoScreen({
    Key? key,
    required this.medicamento,
    required this.onMedicamentoEditado,
  }) : super(key: key);

  @override
  State<EditarMedicamentoScreen> createState() => _EditarMedicamentoScreenState();
}

class _EditarMedicamentoScreenState extends State<EditarMedicamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _dosisController;
  late TextEditingController _notasController;
  late String _frecuenciaSeleccionada;
  late List<TimeOfDay> _horarios;

  final List<String> _frecuencias = [
    'Una vez al día',
    'Cada 8 horas',
    'Cada 12 horas',
    'Dos veces al día',
    'Tres veces al día',
    'Personalizado',
  ];

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.medicamento.nombre);
    _dosisController = TextEditingController(text: widget.medicamento.dosis);
    _notasController = TextEditingController(text: widget.medicamento.notas);
    _frecuenciaSeleccionada = widget.medicamento.frecuencia;
    _horarios = List.from(widget.medicamento.horarios);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Medicamento'),
        actions: [
          TextButton(
            onPressed: _guardarCambios,
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información del Medicamento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre del medicamento',
                  prefixIcon: Icon(Icons.medication, color: Colors.blue[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa el nombre del medicamento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosisController,
                decoration: InputDecoration(
                  labelText: 'Dosis',
                  prefixIcon: Icon(Icons.straighten, color: Colors.blue[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa la dosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Notas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notasController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Instrucciones especiales',
                  prefixIcon: Icon(Icons.note, color: Colors.blue[700]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _guardarCambios() {
    if (_formKey.currentState!.validate()) {
      final medicamentoEditado = Medicamento(
        id: widget.medicamento.id,
        nombre: _nombreController.text,
        dosis: _dosisController.text,
        frecuencia: _frecuenciaSeleccionada,
        horarios: _horarios,
        notas: _notasController.text,
        fechaInicio: widget.medicamento.fechaInicio,
        tomadoHoy: widget.medicamento.tomadoHoy,
      );

      widget.onMedicamentoEditado(medicamentoEditado);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${medicamentoEditado.nombre} actualizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}