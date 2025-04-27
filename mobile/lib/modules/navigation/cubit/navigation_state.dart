part of 'navigation_cubit.dart';

final class NavigationState {
  final String path;
  NavigationState({required this.path});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationState &&
          runtimeType == other.runtimeType &&
          path == other.path;

  int getIndex() {
    if (path.startsWith('/home')) return 0;
    if (path.startsWith('/profile')) return 1;
    return 0;
  }

  @override
  int get hashCode => path.hashCode;
}
