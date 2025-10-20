import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:javerage_timer/features/timer/domain/repositories/timer_repository.dart';

part 'timer_event.dart';
part 'timer_state.dart';

/// The TimerBloc class in Dart is responsible for managing timer events and states, utilizing a
/// TimerRepository for functionality like starting, ticking, pausing, and resetting timers.
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required TimerRepository timerRepository})
      : _timerRepository = timerRepository,
        super(const TimerInitial(_duration)) {
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerReset>(_onReset);
    on<TimerDurationChanged>(_onDurationChanged);
  }

  final TimerRepository _timerRepository;
  static const int _duration = 60;
  int _initialDuration = _duration;
  int _cycles = 1;
  int _currentCycle = 0;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    _currentCycle = 1;
    _cycles = event.cycles ?? 1;
    _initialDuration = event.duration;
    emit(TimerTicking(event.duration, currentCycle: 1, totalCycles: _cycles));
    _tickerSubscription?.cancel();
    _tickerSubscription = _timerRepository
        .ticker()
        .listen((ticks) {
          final remaining = event.duration - ticks;
          if (remaining >= 0) {
            add(TimerTicked(duration: remaining));
          }
        });
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      // Solo emitir si el estado realmente cambió (optimización crítica)
      if (state.duration != event.duration) {
        emit(TimerTicking(event.duration, currentCycle: _currentCycle, totalCycles: _cycles));
      }
    } else {
      // Timer reached 0 - emitir TimerFinished primero
      emit(const TimerFinished());
      
      // Si hay más ciclos, programar el inicio del siguiente ciclo
      if (_currentCycle < _cycles) {
        _currentCycle++;
        // Usar Future.delayed para evitar bloqueos
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) {
            add(TimerStarted(duration: _initialDuration, cycles: _cycles));
          }
        });
      }
    }
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerTicking) {
      _tickerSubscription?.pause();
      emit(TimerInitial(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    _currentCycle = 1;
    _cycles = 1;
    emit(TimerInitial(_initialDuration));
  }

  void _onDurationChanged(TimerDurationChanged event, Emitter<TimerState> emit) {
    _initialDuration = event.duration;
    emit(TimerInitial(event.duration));
  }
}
