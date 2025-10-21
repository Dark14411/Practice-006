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
    on<TimerLap>(_onLap);
  }

  final TimerRepository _timerRepository;
  static const int _duration = 60;
  int _initialDuration = _duration;
  int _cycles = 1;
  int _currentCycle = 0;
  List<int> _lapTimes = [];
  int _totalTime = 0;
  int _currentLap = 0;
  DateTime? _startTime;
  DateTime? _lastLapTime;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    print('DEBUG: ========== _onStarted CALLED ==========');
    print('DEBUG: event.duration = ${event.duration}');
    print('DEBUG: _initialDuration BEFORE = $_initialDuration');
    print('DEBUG: Timer started with duration: ${event.duration}');
    _currentCycle = 1;
    _cycles = event.cycles ?? 1;
    _initialDuration = event.duration;
    print('DEBUG: _initialDuration AFTER = $_initialDuration');
    _lapTimes = [];
    _totalTime = 0;
    _currentLap = 0;
    _startTime ??= DateTime.now();
    emit(TimerTicking(event.duration, currentCycle: 1, totalCycles: _cycles, lapTimes: _lapTimes, totalTime: _totalTime, currentLap: _currentLap));
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
        emit(TimerTicking(event.duration, currentCycle: _currentCycle, totalCycles: _cycles, lapTimes: _lapTimes, totalTime: _totalTime, currentLap: _currentLap));
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
      emit(TimerPauseState(state.duration, currentCycle: _currentCycle, totalCycles: _cycles, lapTimes: _lapTimes, totalTime: _totalTime, currentLap: _currentLap));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    _currentCycle = 1;
    _cycles = 1;
    _lapTimes = [];
    _totalTime = 0;
    _currentLap = 0;
    _startTime = null;
    _lastLapTime = null;
    emit(TimerInitial(_initialDuration));
  }

  void _onDurationChanged(TimerDurationChanged event, Emitter<TimerState> emit) {
    print('DEBUG: Duration changed to: ${event.duration} seconds');
    _initialDuration = event.duration;
    emit(TimerInitial(event.duration));
  }

  void _onLap(TimerLap event, Emitter<TimerState> emit) {
    if (state is TimerTicking && _startTime != null) {
      final now = DateTime.now();
      
      // Cooldown de 2 segundos entre laps
      if (_lastLapTime != null && 
          now.difference(_lastLapTime!).inSeconds < 2) {
        print('DEBUG: Lap ignored - cooldown active (wait ${2 - now.difference(_lastLapTime!).inSeconds}s)');
        return;
      }
      
      final lapTimeInSeconds = now.difference(_startTime!).inMilliseconds / 1000.0;
      final lapTime = lapTimeInSeconds.round(); // Redondear al segundo más cercano
      
      // Solo registrar laps de al menos 1 segundo para evitar laps accidentales
      if (lapTime >= 1) {
        _lapTimes.add(lapTime);
        _currentLap = _lapTimes.length;
        _totalTime += lapTime;
        _startTime = now; // Reset start time for next lap
        _lastLapTime = now;
        
        print('DEBUG: Lap registered - lapTime: $lapTime seconds, total laps: $_currentLap');
        
        emit(TimerTicking(state.duration, currentCycle: _currentCycle, totalCycles: _cycles, lapTimes: _lapTimes, totalTime: _totalTime, currentLap: _currentLap));
      } else {
        print('DEBUG: Lap ignored - too short ($lapTime seconds)');
      }
    } else {
      print('DEBUG: Lap ignored - timer not running');
    }
  }
}
