# Javerage Timer

Una aplicación de temporizador desarrollada en Flutter siguiendo los principios de **Clean Architecture** y el patrón **BLoC** para la gestión de estado.

![Timer App Demo](assets/images/time-and-date.png)

## 🎯 Características

- ⏱️ Temporizador de cuenta regresiva de 60 segundos
- ▶️ Controles de reproducir, pausar y reiniciar
- 🌊 Fondo animado con efecto de olas
- 📱 Interfaz responsive (orientación vertical y horizontal)
- 🏗️ Arquitectura limpia por capas
- 🧪 Tests unitarios incluidos

## 🏛️ Arquitectura

Este proyecto implementa **Clean Architecture** con una estructura organizada por características (features):

```
lib/
├── core/
│   ├── app/          # Configuración principal de la app
│   └── theme/        # Tema y estilos
└── features/
    └── timer/
        ├── application/    # BLoC (lógica de negocio)
        ├── data/          # Implementaciones de repositorios
        ├── domain/        # Entidades y contratos
        └── presentation/  # UI (pantallas y widgets)
```

### Capas

1. **Domain** (Dominio): Lógica de negocio pura e independiente
   - `Ticker`: Entidad que genera el flujo de tiempo
   - `TimerRepository`: Contrato abstracto

2. **Data** (Datos): Implementación de los contratos del dominio
   - `TimerRepositoryImpl`: Implementación concreta del repositorio

3. **Application** (Aplicación): Orquestación con BLoC
   - `TimerBloc`: Maneja los eventos y estados del temporizador
   - Estados: `TimerInitial`, `TimerTicking`, `TimerFinished`
   - Eventos: `TimerStarted`, `TimerTicked`, `TimerPaused`, `TimerReset`

4. **Presentation** (Presentación): Interfaz de usuario
   - Widgets reutilizables y pantallas

## 🛠️ Tecnologías

- **Flutter**: Framework de desarrollo
- **flutter_bloc**: Gestión de estado reactivo
- **equatable**: Optimización de comparaciones
- **wave**: Animaciones de fondo

## 🚀 Comenzando

### Prerrequisitos

- Flutter SDK (3.9.2 o superior)
- Dart SDK
- Un emulador configurado o dispositivo físico

### Instalación

1. Clonar el repositorio:
```bash
git clone <repository-url>
cd javerage_timer
```

2. Obtener las dependencias:
```bash
flutter pub get
```

3. Ejecutar la aplicación:
```bash
flutter run --debug
```

### Ejecutar Tests

```bash
flutter test
```

## 📖 Aprendizajes Clave

Este proyecto fue diseñado como herramienta educativa para aprender:

- ✅ Arquitectura limpia en Flutter
- ✅ Patrón BLoC para gestión de estado
- ✅ Separación de responsabilidades
- ✅ Inyección de dependencias
- ✅ Testing de widgets
- ✅ Uso eficiente de Streams
- ✅ Optimización de rebuilds con `BlocBuilder` y `buildWhen`

## 🎨 Personalización

### Cambiar la duración del temporizador

Edita la constante `_duration` en `lib/features/timer/application/timer_bloc.dart`:

```dart
static const int _duration = 60; // Cambia este valor
```

### Personalizar el tema

Modifica los colores en `lib/core/theme/app_theme.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color.fromRGBO(72, 74, 126, 1), // Tu color aquí
),
```

## 🔮 Desafíos Propuestos

1. **Duración Personalizable**: Permitir al usuario ingresar una duración personalizada
2. **Retroalimentación Visual**: Agregar un `CircularProgressIndicator` que se agote visualmente
3. **Notificaciones Sonoras**: Reproducir un sonido cuando el temporizador llegue a cero
4. **Agregar Vueltas (Laps)**: Registrar tiempos de vuelta sin detener el temporizador

## 📄 Licencia

Este proyecto fue creado con fines educativos.

## 🙏 Agradecimientos

Inspirado en el tutorial de BLoC de [bloclibrary.dev](https://bloclibrary.dev/)

---

Desarrollado con ❤️ usando Flutter & BLoC
