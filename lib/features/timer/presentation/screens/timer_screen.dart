import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:javerage_timer/features/timer/application/timer_bloc.dart';
import 'package:javerage_timer/features/timer/data/repositories/timer_repository_impl.dart';
import 'package:javerage_timer/features/timer/domain/entities/ticker.dart';
import 'package:javerage_timer/features/timer/presentation/widgets/timer_view.dart';

/// The TimerScreen class is a StatelessWidget that provides a TimerBloc to its child TimerView.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(timerRepository: TimerRepositoryImpl(const Ticker())),
      child: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) async {
          if (state is TimerFinished) {
            try {
              await _audioPlayer.stop();
              await _audioPlayer.play(AssetSource('sounds/biohazard-alarm-143105.mp3'));
            } catch (e) {
              debugPrint('Error playing sound: $e');
            }
          } else if (state is TimerInitial || state is TimerTicking) {
            // Detener el sonido cuando se reinicia o se pausa
            try {
              await _audioPlayer.stop();
            } catch (e) {
              debugPrint('Error stopping sound: $e');
            }
          }
        },
        child: const TimerView(),
      ),
    );
  }
}
