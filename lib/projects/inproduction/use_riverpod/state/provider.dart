import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider extract state out
final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});
