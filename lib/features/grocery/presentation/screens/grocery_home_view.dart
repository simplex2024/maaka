import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/shop_card.dart';
import '../../../../core/widgets/module_header.dart';
import '../../../../core/widgets/module_search_bar.dart';
import '../bloc/grocery_bloc.dart';
import '../bloc/grocery_event.dart';
import '../bloc/grocery_state.dart';

class GroceryHomeView extends StatefulWidget {
  const GroceryHomeView({super.key});

  @override
  State<GroceryHomeView> createState() => _GroceryHomeViewState();
}

class _GroceryHomeViewState extends State<GroceryHomeView> {
  final TextEditingController _searchController = TextEditingController();
  final String _location = 'Nesapakkam, Chennai';

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
        bottom: false,
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return ModuleHeader(
      moduleName: 'grocery',
      themeColor: const Color(0xFF26AC73),
      location: _location,
      actions: [
        ModuleActionIcon(
          icon: Icons.notifications_none,
          iconColor: AppColors.blackprimaryapp,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        ModuleActionIcon(
          icon: Icons.shopping_cart_outlined,
          iconColor: AppColors.blackprimaryapp,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        ModuleActionIcon(
          icon: Icons.phone_outlined,
          iconColor: AppColors.blackprimaryapp,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return ModuleSearchBar(
      controller: _searchController,
      themeColor: const Color(0xFF26AC73),
      onChanged: (query) {
        context.read<GroceryBloc>().add(GrocerySearchChanged(query));
      },
      onSubmitted: (query) {
        context.read<GroceryBloc>().add(GrocerySearchRequested(query));
      },
      onMicTap: () {},
    );
  }

  Widget _buildFilterButtons(String currentFilter) {
    return Row(
      children: [
        _buildFilterButton(
          label: 'Distance',
          isSelected: currentFilter == 'distance',
          isFilled: true,
          onTap: () {
            context.read<GroceryBloc>().add(
                  const GroceryFilterChanged('distance'),
                );
          },
        ),
        const SizedBox(width: 12),
        _buildFilterButton(
          label: 'rating',
          isSelected: currentFilter == 'rating',
          isFilled: false,
          onTap: () {
            context.read<GroceryBloc>().add(
                  const GroceryFilterChanged('rating'),
                );
          },
        ),
      ],
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required bool isFilled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          color: isFilled ? const Color(0xFF26AC73) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF26AC73),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isFilled ? Colors.white : const Color(0xFF26AC73),
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
        childAspectRatio: 0.68,
      ),
      itemCount: shops.length,
      itemBuilder: (context, index) {
        return ShopCard(shop: shops[index]);
      },
    );
  }
}
