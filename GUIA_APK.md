# 📱 Guía para Compilar y Distribuir el APK

## ✅ Cambios Implementados

### 🎨 Características Nuevas
1. **Colores Rojo/Amarillo**: Las olas ahora tienen gradientes rojo crimson y amarillo dorado
2. **Duración Personalizable**: Tap en el tiempo (cuando está en estado inicial) para configurar minutos y segundos
3. **Sistema de Ciclos**: Botón de repetición (🔁) para configurar cuántas veces repetir el timer
4. **Notificación Sonora**: Alarma de biohazard cuando el contador llega a 0
5. **Visualización de Ciclos**: Muestra "Ciclo X de Y" cuando hay múltiples ciclos configurados

### 📂 Archivos Modificados
- `custom_waves.dart` - Cambio de colores azul → rojo/amarillo
- `timer_text.dart` - Diálogo para configurar duración
- `timer_bloc.dart` - Soporte para ciclos y duración personalizable
- `timer_event.dart` - Nuevo evento `TimerDurationChanged` y parámetro `cycles` en `TimerStarted`
- `timer_state.dart` - Propiedades `currentCycle` y `totalCycles`
- `actions_buttons.dart` - Botón nuevo para configurar ciclos
- `timer_view.dart` - Visualización del ciclo actual
- `timer_screen.dart` - BlocListener para reproducir sonido
- `pubspec.yaml` - Agregado `audioplayers` y assets de sonidos

## 🔧 Compilar el APK

### Opción 1: Usando el Script Batch (Recomendado para Windows)

1. Abre el Explorador de Archivos
2. Navega a: `c:\Users\julio\Desktop\practice 006\javerage_timer`
3. Haz doble clic en `build_apk.bat`
4. Espera a que termine la compilación (puede tardar 2-5 minutos)

### Opción 2: Usando la Terminal

```bash
cd "c:\Users\julio\Desktop\practice 006\javerage_timer"
flutter build apk --release
```

### Opción 3: APK Optimizado (Por ABI)

Para generar APKs más pequeños y optimizados por arquitectura:

```bash
flutter build apk --split-per-abi
```

Esto genera 3 APKs:
- `app-armeabi-v7a-release.apk` (dispositivos ARM 32-bit)
- `app-arm64-v8a-release.apk` (dispositivos ARM 64-bit) ← **Más común**
- `app-x86_64-release.apk` (emuladores y algunos tablets)

## 📦 Ubicación del APK

Después de compilar, el APK estará en:

```
c:\Users\julio\Desktop\practice 006\javerage_timer\build\app\outputs\flutter-apk\
```

Archivos generados:
- **Universal**: `app-release.apk` (funciona en todos los dispositivos)
- **Optimizados** (si usaste --split-per-abi):
  - `app-armeabi-v7a-release.apk`
  - `app-arm64-v8a-release.apk`
  - `app-x86_64-release.apk`

## 📤 Distribución

### Para Instalar en tu Dispositivo

1. **Habilitar "Fuentes Desconocidas"** en tu Android:
   - Configuración → Seguridad → Instalar apps desconocidas
   - O: Configuración → Aplicaciones → Acceso especial → Instalar apps desconocidas

2. **Transferir el APK**:
   - Vía USB: Copia `app-release.apk` a tu dispositivo
   - Vía Email: Envíate el APK por correo
   - Vía Google Drive/Dropbox: Sube el APK a la nube

3. **Instalar**:
   - Abre el APK desde tu dispositivo Android
   - Sigue las instrucciones de instalación

### Para Compartir

- **GitHub**: Ya está subido en https://github.com/Dark14411/Practice-006
- **Google Drive**: Sube el APK y comparte el enlace
- **Release en GitHub**: 
  1. Ve al repositorio
  2. Click en "Releases" → "Create a new release"
  3. Sube el APK como asset

## 🔍 Verificación

### Antes de Distribuir

1. **Probar en Emulador**:
```bash
flutter run --release
```

2. **Verificar Funcionalidades**:
   - ✅ Tap en el tiempo para cambiar duración
   - ✅ Botón de ciclos funciona
   - ✅ Play/Pause/Reset funcionan
   - ✅ Sonido se reproduce al finalizar
   - ✅ Colores rojo/amarillo en el fondo
   - ✅ Indicador de ciclo actual

### Información del APK

Para ver información detallada del APK:

```bash
flutter build apk --release --analyze-size
```

## 🐛 Solución de Problemas

### Error: "Gradle build failed"
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk --release
```

### Error: "audioplayers no encontrado"
```bash
flutter pub get
flutter clean
```

### APK muy grande
Usa `--split-per-abi` para generar APKs optimizados más pequeños.

## 📊 Tamaño Esperado del APK

- **Universal**: ~25-35 MB
- **Split por ABI**: ~18-22 MB cada uno

## 🚀 Repositorio GitHub

El código ya está subido en:
**https://github.com/Dark14411/Practice-006**

Para clonar:
```bash
git clone https://github.com/Dark14411/Practice-006.git
```

## 📝 Notas Finales

- El APK está firmado con una clave de debug (solo para desarrollo)
- Para producción (Google Play Store), necesitas firmarlo con una clave release
- La app requiere Android 5.0 (API 21) o superior
- Permisos requeridos: Internet (para cargar assets), Audio

---

**Creado el**: 20 de Octubre, 2025  
**Versión**: 1.0.0+1  
**Framework**: Flutter 3.9.2+
