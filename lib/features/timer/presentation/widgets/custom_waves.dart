import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

/// The `CustomWaves` class creates a widget with custom wave configurations for a visually appealing
/// design.
class CustomWaves extends StatelessWidget {
  const CustomWaves({super.key});

  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            const Color.fromRGBO(220, 20, 60, 1),  // Rojo Crimson
            const Color.fromRGBO(255, 215, 0, 1),  // Amarillo Dorado
          ],
          [
            const Color.fromRGBO(220, 20, 60, 0.7),
            const Color.fromRGBO(255, 215, 0, 0.7),
          ],
        ],
        // Aumentar duración de animaciones para reducir CPU
        durations: [45000, 35000],
        heightPercentages: [0.28, 0.26],
        // Reducir blur para mejor rendimiento
        blur: const MaskFilter.blur(BlurStyle.solid, 5),
        gradientBegin: Alignment.bottomLeft,
        gradientEnd: Alignment.topRight,
      ),
      // Reducir amplitud para menos cálculos
      waveAmplitude: 25,
      size: const Size(double.infinity, double.infinity),
    );
  }
}
