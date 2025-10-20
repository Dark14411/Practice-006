import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_timer/features/timer/application/timer_bloc.dart';

/// The `ActionsButtons` class in Dart is a stateless widget that displays different action buttons
/// based on the state of a `TimerBloc` in a Flutter application.
class ActionsButtons extends StatelessWidget {
  const ActionsButtons({super.key});

  Future<void> _showCyclesDialog(BuildContext context, int duration) async {
    final TextEditingController cyclesController = TextEditingController(text: '1');
    
    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Configurar Ciclos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¿Cuántas veces deseas repetir el temporizador?'),
              const SizedBox(height: 16),
              TextField(
                controller: cyclesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de ciclos',
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
                final cycles = int.tryParse(cyclesController.text) ?? 1;
                Navigator.pop(dialogContext, cycles);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      context.read<TimerBloc>().add(
        TimerStarted(duration: duration, cycles: result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              TimerInitial() => [
                FloatingActionButton(
                  heroTag: 'play_button',
                  child: const Icon(Icons.play_arrow),
                  onPressed: () => context.read<TimerBloc>().add(
                    TimerStarted(duration: state.duration, cycles: 1),
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'cycles_button',
                  child: const Icon(Icons.repeat),
                  onPressed: () => _showCyclesDialog(context, state.duration),
                ),
              ],
              TimerTicking() => [
                FloatingActionButton(
                  heroTag: 'pause_button',
                  child: const Icon(Icons.pause),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerPaused()),
                ),
                FloatingActionButton(
                  heroTag: 'reset_button',
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
              TimerFinished() => [
                FloatingActionButton(
                  heroTag: 'replay_button',
                  child: const Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
            },
          ],
        );
      },
    );
  }
}
