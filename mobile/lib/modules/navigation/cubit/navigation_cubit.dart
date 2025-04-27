import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(path: "/home"));

  void navigateToIndex({required int index}) {
    String path;
    switch (index) {
      case 0:
        path = "/home";
      case 1:
        path = "/profile";
      default:
        path = "/home";
    }

    emit(NavigationState(path: path));
  }
}
