import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/bottom_menu_item.dart';
import '../../../../core/widgets/maaka_bottom_app_bar.dart';
import '../../../meat/data/datasources/meat_service.dart';
import '../../../meat/data/repositories/meat_repository.dart';
import '../../../meat/presentation/bloc/meat_bloc.dart';
import '../../../meat/presentation/screens/meat_home_view.dart';
import '../../../grocery/presentation/bloc/grocery_bloc.dart';
import '../../../grocery/presentation/bloc/grocery_event.dart';
import '../../../grocery/data/repositories/shop_repository.dart';
import '../../../grocery/data/datasources/shop_service.dart';
import '../../../grocery/presentation/screens/grocery_home_view.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0;

  List<BottomMenuItem> get _menuItems {
    return [
      BottomMenuItem(
        label: 'grocery',
        icon: Icons.shopping_bag,
        onTap: () => setState(() => _selectedIndex = 0),
      ),
      BottomMenuItem(
        label: 'Meat', // Changed from Orders to Meat
        icon: Icons.restaurant_menu, // Changed icon
        onTap: () => setState(() => _selectedIndex = 1),
      ),
      BottomMenuItem(
        label: 'package',
        icon: Icons.inventory_2,
        onTap: () => setState(() => _selectedIndex = 2),
      ),
      BottomMenuItem(
        label: 'piggybank',
        icon: Icons.savings,
        onTap: () => setState(() => _selectedIndex = 3),
      ),
      BottomMenuItem(
        label: 'info',
        icon: Icons.info_outline,
        onTap: () => setState(() => _selectedIndex = 4),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: _buildBody(),
      bottomNavigationBar: MaakaBottomAppBar(
        menuItems: _menuItems,
        selectedIndex: _selectedIndex,
        theme: _getThemeForIndex(_selectedIndex),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const GroceryHomeView();
      case 1:
        return BlocProvider(
          create: (context) => MeatBloc(
            MeatRepository(MeatService()),
          ),
          child: const MeatHomeView(),
        );
      case 2:
        return const Center(child: Text('Package Screen'));
      case 3:
        return const Center(child: Text('Piggybank Screen'));
      case 4:
        return const Center(child: Text('Info Screen'));
      default:
        return const GroceryHomeView();
    }
  }
  BottomMenuTheme _getThemeForIndex(int index) {
    switch (index) {
      case 0:
        return BottomMenuTheme.green;
      case 1:
        return BottomMenuTheme.red;
      case 2:
        return BottomMenuTheme.purple; // Package
      case 3:
        return BottomMenuTheme.orange; // Piggybank
      case 4:
        return BottomMenuTheme.green; // Info
      default:
        return BottomMenuTheme.green;
    }
  }
}

class MainDashboardScreenProvider extends StatelessWidget {
  const MainDashboardScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroceryBloc(
        ShopRepository(ShopService()),
      )..add(
          const GroceryShopsLoaded(
            location: 'Nesapakkam, Chennai',
            filterBy: 'distance',
          ),
        ),
      child: const MainDashboardScreen(),
    );
  }
}
