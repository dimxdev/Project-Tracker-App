import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';

/// Kerangka utama app: 2 tab (Dashboard & Riwayat) + bottom navigation.
///
/// Tiap kali pindah tab, layar dibangun ulang (fresh) supaya datanya selalu
/// terbaru — misalnya Riwayat langsung nampilin task yang baru diselesaikan.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // Dibuat di build() biar tiap pindah tab layarnya fresh (reload data).
    final screens = const [DashboardScreen(), HistoryScreen()];

    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}
