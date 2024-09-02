// This code is distributed under the MIT License.
// Copyright (c) 2018 Felix Angelov.
// You can find the original at https://github.com/felangel/bloc.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'state/bloc_state.dart';
import 'screen/materialapp.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const BlocCounterExample());
}

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}



