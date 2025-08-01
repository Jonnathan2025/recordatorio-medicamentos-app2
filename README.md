# Recordatorio de Medicamentos 💊
Una aplicación móvil desarrollada en Flutter para ayudar a adultos mayores a recordar sus medicamentos mediante notificaciones programadas, una interfaz accesible y funcionalidades de seguimiento.
# Capturas de Pantalla 📱
<img width="385" height="848" alt="image" src="https://github.com/user-attachments/assets/2f602624-5e0c-4d02-937c-2f1da167fd54" />
<img width="384" height="843" alt="image" src="https://github.com/user-attachments/assets/a06d979f-aa75-44d2-b3bb-fb677c0ebca3" />
<img width="381" height="844" alt="image" src="https://github.com/user-attachments/assets/8f6963e9-75ae-41de-b41f-fd1bedb8af1e" />
🎯 Características Principales
# Funcionalidades Core

📋 Gestión de Medicamentos: Agregar, editar y eliminar medicamentos
⏰ Horarios Personalizados: Configurar múltiples horarios diarios
🔔 Recordatorios Inteligentes: Notificaciones automáticas para cada toma
📊 Seguimiento de Adherencia: Estadísticas de cumplimiento
📅 Historial Completo: Registro detallado de tomas realizadas y perdidas

# Diseño Centrado en Adultos Mayores

🔤 Tipografía Grande: Texto legible y contrastado
🎨 Interfaz Simplificada: Navegación intuitiva con íconos claros
✋ Botones Accesibles: Elementos táctiles de gran tamaño
🎯 Flujo Simplificado: Minimal pasos para completar tareas

# Requisitos del Sistema
HerramientaVersión MínimaFlutter3.16.0Dart3.2.0AndroidAPI 21 (Android 5.0)iOSiOS 12.0
📁 Estructura del Proyecto
lib/
├── main.dart                      # Punto de entrada de la aplicación
├── models/
│   ├── medicamento.dart          # Modelo de datos del medicamento
│   └── registro_toma.dart        # Modelo de registro de tomas
├── screens/
│   ├── home_screen.dart          # Pantalla principal con navegación
│   ├── agregar_medicamento.dart  # Formulario para nuevo medicamento
│   └── editar_medicamento.dart   # Formulario de edición
├── services/
│   ├── database_service.dart     # Gestión de base de datos SQLite
│   ├── notification_service.dart # Servicio de notificaciones
│   └── storage_service.dart      # Persistencia de datos
├── widgets/
│   ├── medicamento_card.dart     # Tarjeta de medicamento
│   ├── estadistica_card.dart     # Widgets de estadísticas
│   └── empty_state.dart          # Estados vacíos
└── utils/
    ├── theme.dart                # Tema y colores de la app
    ├── constants.dart            # Constantes globales
    └── accessibility.dart        # Configuraciones de accesibilidad

# Contexto Académico
Este proyecto forma parte de la tesis:
"Diseño e Implementación de una Aplicación móvil para la gestión de medicación y recordatorios en adultos mayores"

Universidad: Universidad Internacional SEK
Programa: Adultos mayores
Año: 2025
Tutor:Jonnathan Castillo


