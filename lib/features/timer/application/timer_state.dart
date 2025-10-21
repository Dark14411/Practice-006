part of 'timer_bloc.dart';

/// The `sealed class TimerState extends Equatable` in Dart is defining a base class `TimerState` that
/// is marked as `sealed`. In Dart, a sealed class restricts its subclasses to be defined in the same
/// file. This helps in ensuring that all possible subclasses of `TimerState` are known and handled
/// within the same file.
sealed class TimerState extends Equatable {
  const TimerState(this.duration, {
    this.currentCycle = 1,
    this.totalCycles = 1,
    this.lapTimes = const [],
    this.totalTime = 0,
    this.currentLap = 0,
  });

  final int duration;
  final int currentCycle;
  final int totalCycles;
  final List<int> lapTimes; // Tiempos parciales en segundos
  final int totalTime; // Tiempo total acumulado
  final int currentLap; // Vuelta actual (1-100)

  @override
  List<Object> get props => [duration, currentCycle, totalCycles, lapTimes, totalTime, currentLap];
}

/// The `TimerInitial` class represents the initial state of a timer with a specified duration in Dart.
class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

/// The `TimerTicking` class represents the state of a timer that is currently ticking with a specific
/// duration.
class TimerTicking extends TimerState {
  const TimerTicking(super.duration, {
    super.currentCycle,
    super.totalCycles,
    super.lapTimes,
    super.totalTime,
    super.currentLap,
  });

  @override
  String toString() => 'TimerTicking { duration: $duration, cycle: $currentCycle/$totalCycles, lap: $currentLap }';
}

/// The `TimerFinished` class represents a state where the timer has finished.
class TimerFinished extends TimerState {
  const TimerFinished({
    super.lapTimes = const [],
    super.totalTime = 0,
    super.currentLap = 0,
  }) : super(0);

  @override
  String toString() => 'TimerFinished { laps: $currentLap, total: $totalTime }';
}

/// The `TimerPauseState` class represents a state where the timer is paused.
class TimerPauseState extends TimerState {
  const TimerPauseState(super.duration, {
    super.currentCycle,
    super.totalCycles,
    super.lapTimes,
    super.totalTime,
    super.currentLap,
  });

  @override
  String toString() => 'TimerPauseState { duration: $duration, cycle: $currentCycle/$totalCycles, lap: $currentLap }';
}
