import 'package:flutter/material.dart';
import '../Pages/input.dart';
import '../Pages/output.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    InputScreen(),
    OutputScreen(),
  ];

  final List<String> _titles = [
    'Input',
    'Output',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.green.shade50,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.input_outlined),
                  label: Text('Input'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.table_chart_outlined),
                  label: Text('Output'),
                ),
              ],
            ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green.shade50,
                title: Text(
                  _titles[_selectedIndex],
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
              ),
              body: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.input_outlined),
            label: 'Input',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_chart_outlined),
            label: 'Output',
          ),
        ],
      ),
    );
  }
}
