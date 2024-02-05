import 'package:flutter_bloc/flutter_bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());
  void increment() {
    emit(CounterState(count: state.count + 1));
  }

  void decrement() {
    if (state.count > 2) {
      emit(CounterState(count: state.count - 1));
    } else {
      emit(const CounterState(count: 1));
    }
  }
}
