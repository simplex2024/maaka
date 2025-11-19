import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/widgets/maaka_bottom_app_bar.dart';
import '../../../core/models/bottom_menu_item.dart';
import '../../../core/widgets/shop_card.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../data/services/shop_service.dart';
import '../bloc/grocery_bloc.dart';
import '../bloc/grocery_event.dart';
import '../bloc/grocery_state.dart';

class GroceryDashboardScreen extends StatefulWidget {
  const GroceryDashboardScreen({super.key});

  @override
  State<GroceryDashboardScreen> createState() => _GroceryDashboardScreenState();
}

class _GroceryDashboardScreenState extends State<GroceryDashboardScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final String _location = 'Nesapakkam, Chennai';

  List<BottomMenuItem> get _menuItems {
    return [
      BottomMenuItem(
        label: 'grocery',
        icon: Icons.shopping_bag,
        onTap: () => setState(() => _selectedIndex = 0),
      ),
      BottomMenuItem(
        label: 'orders',
        icon: Icons.history,
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
  void initState() {
    super.initState();
    // Load shops when screen initializes
    context.read<GroceryBloc>().add(
          GroceryShopsLoaded(
            location: _location,
            filterBy: 'distance',
          ),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            _buildSearchBar(),
            // Main Content
            Expanded(
              child: BlocBuilder<GroceryBloc, GroceryState>(
                builder: (context, state) {
                  if (state.isLoading && state.shops.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.isFailure && state.shops.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? 'Something went wrong',
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<GroceryBloc>().add(
                                    GroceryShopsLoaded(
                                      location: _location,
                                      filterBy: state.filterBy,
                                    ),
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading
                        const Text(
                          "Grocery's shops near by you",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackprimaryapp,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Filter Buttons
                        _buildFilterButtons(state.filterBy),
                        const SizedBox(height: 16),
                        // Shop Grid
                        if (state.shops.isEmpty && !state.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('No shops found'),
                            ),
                          )
                        else
                          _buildShopGrid(state.shops),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MaakaBottomAppBar(
        menuItems: _menuItems,
        selectedIndex: _selectedIndex,
        theme: BottomMenuTheme.green,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Maaka',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackprimaryapp,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'grocery',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4CAF50), // Green
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.blacksecondaryapp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _buildActionIcon(Icons.notifications_none),
              const SizedBox(width: 12),
              _buildActionIcon(Icons.shopping_cart_outlined),
              const SizedBox(width: 12),
              _buildActionIcon(Icons.phone_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 20,
        color: AppColors.blackprimaryapp,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50), // Green
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Shop',
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white,
            size: 24,
          ),
          suffixIcon: IconButton(
            icon: Image.asset(
              IconImages.micImage,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
            onPressed: () {
              // Handle microphone tap
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        style: const TextStyle(color: Colors.white),
        onChanged: (query) {
          context.read<GroceryBloc>().add(GrocerySearchChanged(query));
        },
        onSubmitted: (query) {
          context.read<GroceryBloc>().add(GrocerySearchRequested(query));
        },
      ),
    );
  }

  Widget _buildFilterButtons(String currentFilter) {
    return Row(
      children: [
        Expanded(
          child: _buildFilterButton(
            label: 'Distance',
            isSelected: currentFilter == 'distance',
            onTap: () {
              context.read<GroceryBloc>().add(
                    const GroceryFilterChanged('distance'),
                  );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildFilterButton(
            label: 'rating',
            isSelected: currentFilter == 'rating',
            onTap: () {
              context.read<GroceryBloc>().add(
                    const GroceryFilterChanged('rating'),
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF50)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF4CAF50),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF4CAF50),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShopGrid(List shops) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: shops.length,
      itemBuilder: (context, index) {
        return ShopCard(shop: shops[index]);
      },
    );
  }
}

// BLoC Provider wrapper
class GroceryDashboardScreenProvider extends StatelessWidget {
  const GroceryDashboardScreenProvider({super.key});

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
      child: const GroceryDashboardScreen(),
    );
  }
}
