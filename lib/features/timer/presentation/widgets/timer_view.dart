import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_timer/features/timer/application/timer_bloc.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/actions_buttons.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/background.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/timer_text.dart';

/// The TimerView class in Dart defines a widget for displaying a timer with associated actions in a
/// responsive layout.
class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Timer')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxHeight > constraints.maxWidth;
          final verticalPadding = isPortrait
              ? constraints.maxHeight * 0.1
              : constraints.maxHeight * 0.05;
          return Stack(
            children: [
              const Background(),
              _TimerView(verticalPadding: verticalPadding),
            ],
          );
        },
      ),
    );
  }
}

/// The _TimerView class is a StatelessWidget in Dart that displays a TimerText widget with specified
/// vertical padding and ActionButtons below it.
class _TimerView extends StatelessWidget {
  const _TimerView({required this.verticalPadding});

  final double verticalPadding;

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              child: Column(
                children: [
                  const Center(child: TimerText()),
                  if (state.totalCycles > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Ciclo ${state.currentCycle} de ${state.totalCycles}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  if (state.lapTimes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          Text(
                            'Vueltas Registradas',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 150),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.lapTimes.length,
                              itemBuilder: (context, index) {
                                final lapNumber = index + 1;
                                final lapTime = state.lapTimes[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Vuelta $lapNumber:',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _formatTime(lapTime),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tiempo total: ${_formatTime(state.totalTime)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const ActionsButtons(),
          ],
        );
      },
    );
  }
}
