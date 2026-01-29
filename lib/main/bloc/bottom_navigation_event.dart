abstract class BottomNavigationEvent {}

class BottomTabChanged extends BottomNavigationEvent {
  final int index;
  BottomTabChanged(this.index);
}
