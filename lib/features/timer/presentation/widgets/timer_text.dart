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
          title: const Text('Configurar Duración'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Minutos',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: secondsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Segundos',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final minutes = int.tryParse(minutesController.text) ?? 0;
                final seconds = int.tryParse(secondsController.text) ?? 0;
                Navigator.pop(dialogContext, {'minutes': minutes, 'seconds': seconds});
              },
              child: const Text('Aceptar'),
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
    
    return GestureDetector(
      onTap: state is TimerInitial ? () => _showDurationDialog(context) : null,
      child: Text(
        '$minutesStr:$secondsStr',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
