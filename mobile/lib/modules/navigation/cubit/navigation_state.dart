part of 'navigation_cubit.dart';

final class NavigationState {
  final int index;
  NavigationState({required this.index});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationState &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;
}
