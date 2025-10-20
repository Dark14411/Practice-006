# Javerage Timer

Una aplicación de temporizador desarrollada en Flutter siguiendo los principios de **Clean Architecture** y el patrón **BLoC** para la gestión de estado.

![Timer App Demo](assets/images/time-and-date.png)

## 🎯 Características

- ⏱️ **Temporizador personalizable** - Configura la duración que desees (tap en el tiempo para cambiarla)
- 🔁 **Sistema de ciclos** - Repite el temporizador automáticamente N veces
- 🔊 **Notificación sonora** - Alarma de biohazard cuando el timer llega a cero
- 🌊 **Fondo animado** con gradientes rojo y amarillo
- ▶️ Controles completos: play, pause, reset y repetir
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
- **audioplayers**: Reproducción de sonidos

## 🚀 Comenzando

### Prerrequisitos

- Flutter SDK (3.9.2 o superior)
- Dart SDK
- Un emulador configurado o dispositivo físico

### Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/Dark14411/Practice-006.git
cd Practice-006
```

2. Obtener las dependencias:
```bash
flutter pub get
```

3. Ejecutar la aplicación:
```bash
flutter run --debug
```

### Compilar APK

Para generar el APK de la aplicación:

**Opción 1: Usando el script (Windows)**
```bash
build_apk.bat
```

**Opción 2: Comando manual**
```bash
flutter build apk --release
```

El APK se generará en: `build/app/outputs/flutter-apk/app-release.apk`

## 📱 Cómo Usar

1. **Configurar duración**: Tap en el tiempo mostrado (01:00) cuando el timer esté en estado inicial
2. **Configurar ciclos**: Presiona el botón de repetir (🔁) antes de iniciar
3. **Iniciar timer**: Presiona el botón play (▶️)
4. **Pausar**: Presiona el botón pause (⏸️) mientras el timer está corriendo
5. **Reiniciar**: Presiona el botón replay (🔄) para volver al inicio

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
- ✅ Manejo de audio con AudioPlayers
- ✅ Gestión de ciclos y repeticiones

## 🎨 Personalización

### Cambiar los colores de las olas

Edita los gradientes en `lib/features/timer/presentation/widgets/custom_waves.dart`:

```dart
gradients: [
  [
    const Color.fromRGBO(220, 20, 60, 1),  // Rojo Crimson
    const Color.fromRGBO(255, 215, 0, 1),  // Amarillo Dorado
  ],
  // ... más gradientes
]
```

### Cambiar el sonido de la alarma

Reemplaza el archivo en `assets/sounds/biohazard-alarm-143105.mp3` con tu sonido personalizado y actualiza la referencia en `timer_screen.dart`.

### Personalizar el tema

Modifica los colores en `lib/core/theme/app_theme.dart`:

```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color.fromRGBO(72, 74, 126, 1), // Tu color aquí
),
```

## ✨ Características Implementadas

- ✅ **Duración Personalizable**: Tap en el tiempo para configurar duración custom
- ✅ **Sistema de Ciclos**: Botón de repetición para configurar múltiples ciclos
- ✅ **Notificación Sonora**: Alarma de biohazard al finalizar el timer
- ✅ **Colores Personalizados**: Gradientes rojo y amarillo en las olas

## 🔮 Desafíos Adicionales

1. **Retroalimentación Visual**: Agregar un `CircularProgressIndicator` que se agote visualmente
2. **Agregar Vueltas (Laps)**: Registrar tiempos de vuelta sin detener el temporizador
3. **Persistencia**: Guardar configuraciones y última duración usada
4. **Modo Oscuro**: Implementar tema oscuro/claro

## 📄 Licencia

Este proyecto fue creado con fines educativos.

## 🙏 Agradecimientos

Inspirado en el tutorial de BLoC de [bloclibrary.dev](https://bloclibrary.dev/)

---

Desarrollado con ❤️ usando Flutter & BLoC
