part of 'timer_bloc.dart';

/// The `sealed class TimerState extends Equatable` in Dart is defining a base class `TimerState` that
/// is marked as `sealed`. In Dart, a sealed class restricts its subclasses to be defined in the same
/// file. This helps in ensuring that all possible subclasses of `TimerState` are known and handled
/// within the same file.
sealed class TimerState extends Equatable {
  const TimerState(this.duration, {this.currentCycle = 1, this.totalCycles = 1});
  final int duration;
  final int currentCycle;
  final int totalCycles;

  @override
  List<Object> get props => [duration, currentCycle, totalCycles];
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
  const TimerTicking(super.duration, {super.currentCycle, super.totalCycles});

  @override
  String toString() => 'TimerTicking { duration: $duration, cycle: $currentCycle/$totalCycles }';
}

/// The `TimerFinished` class represents a state where the timer has finished.
class TimerFinished extends TimerState {
  const TimerFinished() : super(0);
}
