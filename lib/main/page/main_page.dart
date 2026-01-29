import 'package:contacts_phone/main/bloc/bottom_navigation_bloc.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> allPages = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavigationBloc, BottomNavigationState>(
      listener: (context, state) {
        setState(() {});
      },
      builder: (context, state) {
        return Scaffold();
      },
    );
  }
}
