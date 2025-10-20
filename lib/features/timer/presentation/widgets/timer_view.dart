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
