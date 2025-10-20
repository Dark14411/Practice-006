import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_timer/features/timer/application/timer_bloc.dart';

/// The TimerText class is a StatelessWidget in Dart that displays a timer in minutes and seconds
/// format.
class TimerText extends StatelessWidget {
  const TimerText({super.key});

  Future<void> _showDurationDialog(BuildContext context) async {
    final TextEditingController minutesController = TextEditingController();
    final TextEditingController secondsController = TextEditingController();
    
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('⏱️ Configurar Duración'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: const InputDecoration(
                  labelText: '⏰ Minutos (0-999)',
                  helperText: 'Ingresa los minutos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                  counterText: '',
                ),
                onChanged: (value) {
                  // Validar que solo sean números
                  if (value.isNotEmpty && int.tryParse(value) == null) {
                    minutesController.text = value.substring(0, value.length - 1);
                    minutesController.selection = TextSelection.fromPosition(
                      TextPosition(offset: minutesController.text.length),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: '⏱️ Segundos (0-59)',
                  helperText: 'Ingresa los segundos',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer_outlined),
                  counterText: '',
                ),
                onChanged: (value) {
                  // Validar que solo sean números y máximo 59
                  if (value.isNotEmpty) {
                    final num = int.tryParse(value);
                    if (num == null) {
                      secondsController.text = value.substring(0, value.length - 1);
                      secondsController.selection = TextSelection.fromPosition(
                        TextPosition(offset: secondsController.text.length),
                      );
                    } else if (num > 59) {
                      secondsController.text = '59';
                      secondsController.selection = TextSelection.fromPosition(
                        TextPosition(offset: secondsController.text.length),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 8),
              const Text(
                'Ejemplo: 2 minutos y 30 segundos = 2:30',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('❌ Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final minutes = int.tryParse(minutesController.text) ?? 0;
                final seconds = int.tryParse(secondsController.text) ?? 0;
                
                // Validar que al menos uno sea mayor a 0
                if (minutes == 0 && seconds == 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ Ingresa al menos 1 segundo'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                
                Navigator.pop(dialogContext, {'minutes': minutes, 'seconds': seconds});
              },
              child: const Text('✅ Aceptar'),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      final totalSeconds = (result['minutes']! * 60) + result['seconds']!;
      if (totalSeconds > 0) {
        context.read<TimerBloc>().add(TimerDurationChanged(duration: totalSeconds));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final state = context.select((TimerBloc bloc) => bloc.state);
    final minutesStr = (duration ~/ 60).toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');
    
    // Verificar si el timer está corriendo
    final isRunning = state is TimerTicking;
    
    return GestureDetector(
      onTap: state is TimerInitial ? () => _showDurationDialog(context) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador circular de progreso
          if (isRunning)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Tiempo principal
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$minutesStr:$secondsStr',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 72,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              
              // Hint para tap cuando está en estado inicial
              if (state is TimerInitial)
                Positioned(
                  bottom: -24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.touch_app, size: 14, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          'Toca para configurar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
