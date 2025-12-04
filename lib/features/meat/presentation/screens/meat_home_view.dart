import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/module_header.dart';
import '../../../../core/widgets/module_search_bar.dart';
import '../../data/models/meat_model.dart';
import '../bloc/meat_bloc.dart';
import '../bloc/meat_event.dart';
import '../bloc/meat_state.dart';
import '../widgets/meat_product_card.dart';
import 'meat_order_details_screen.dart';

class MeatHomeView extends StatefulWidget {
  const MeatHomeView({super.key});

  @override
  State<MeatHomeView> createState() => _MeatHomeViewState();
}

class _MeatHomeViewState extends State<MeatHomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MeatBloc>().add(LoadMeatCategories());
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
      body: BlocBuilder<MeatBloc, MeatState>(
        builder: (context, state) {
          if (state.status == MeatStatus.loading && state.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC2185B)));
          }

          if (state.status == MeatStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Meat List's",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackprimaryapp,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCategories(state.categories, state.selectedCategoryId),
                      const SizedBox(height: 24),
                      _buildProductGrid(state.products),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return ModuleHeader(
      moduleName: 'Meat',
      themeColor: const Color(0xFFC2185B),
      actions: [
        ModuleActionIcon(
          icon: Icons.shopping_cart_outlined,
          backgroundColor: const Color(0xFFC2185B),
          iconColor: Colors.white,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        ModuleActionIcon(
          icon: Icons.phone_outlined,
          backgroundColor: const Color(0xFFC2185B),
          iconColor: Colors.white,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return ModuleSearchBar(
      controller: _searchController,
      themeColor: const Color(0xFFC2185B),
      onMicTap: () {},
    );
  }

  Widget _buildCategories(List<MeatCategory> categories, String selectedId) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedId;
          
          return GestureDetector(
            onTap: () {
              context.read<MeatBloc>().add(SelectMeatCategory(category.id));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFC2185B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC2185B),
                ),
              ),
              child: Text(
                category.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFC2185B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(List<MeatProduct> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return MeatProductCard(
          product: products[index],
          onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeatOrderDetailsScreen(product: products[index]),
              ),
            );
          },
        );
      },
    );
  }
}
