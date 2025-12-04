import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/bottom_menu_item.dart';
import '../../../../core/widgets/maaka_bottom_app_bar.dart';
import '../../../../core/services/auth_session_service.dart';
import '../../data/models/product_model.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/grocery_item_card.dart';

import '../../../../features/auth/presentation/screens/login_screen.dart';
import '../../../checkout/presentation/screens/cart_screen.dart';
import '../../../checkout/presentation/bloc/checkout_bloc.dart';
import '../../../checkout/presentation/bloc/checkout_event.dart';
import '../../../checkout/data/repositories/order_repository.dart';
import '../../../checkout/data/datasources/order_service.dart';

import '../../../../features/grocery/data/models/shop_models.dart';

class ProductListScreen extends StatefulWidget {
  final ShopData shop;

  const ProductListScreen({
    super.key,
    required this.shop,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  int _selectedIndex = 0;
  
  // Validation
  String? _nameError;
  final _formKey = GlobalKey<FormState>();
  final AuthSessionService _authService = AuthSessionService();

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
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isAuthenticated = await _authService.isAuthenticated();
    if (!mounted) return;

    if (!isAuthenticated) {
      // Navigate to login if not authenticated
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // Load products and init speech if authenticated
      context.read<ProductBloc>().add(
            LoadProducts(
              shopId: widget.shop.name, // Using name as ID for now
              shopName: widget.shop.name,
            ),
          );
      _initSpeech();
    }
  }

  Future<void> _initSpeech() async {
    await _speech.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  void _startListening() async {
    if (!_isListening && _speech.isAvailable) {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            context.read<ProductBloc>().add(
                  ProcessVoiceInput(result.recognizedWords),
                );
            setState(() => _isListening = false);
          }
        },
      );
    }
  }

  void _stopListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: _buildAppBar(),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is GroceryListSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Grocery list saved successfully!'),
                backgroundColor: Color(0xFF26AC73),
              ),
            );
            // TODO: Navigate to cart/checkout screen
            // Navigator.pushNamed(context, '/cart', arguments: state.groceryList);
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductLoaded) {
            return _buildContent(state);
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),

    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFE0E0E0),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackprimaryapp, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildShopDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.shop.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.shop.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackprimaryapp,
                            ),
                          ),
                        ),
                        Text(
                          '(${widget.shop.distance})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.blacksecondaryapp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'Owned by : ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.blacksecondaryapp,
                          ),
                        ),
                        Text(
                          widget.shop.owner,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackprimaryapp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/owner_avatar.png'), // Placeholder
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Open till 9 PM',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.blackprimaryapp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.shop.rating,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackprimaryapp,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProductLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShopDetailsCard(),
          const SizedBox(height: 24),
          _buildCreateListSection(),
          const SizedBox(height: 24),
          _buildVoiceSection(),
          const SizedBox(height: 24),
          if (state.groceryItems.isNotEmpty) ...[
            _buildGroceryList(state.groceryItems),
            const SizedBox(height: 24),
          ],
          _buildActionButtons(state.groceryItems.isNotEmpty),
        ],
      ),
    );
  }

  Widget _buildCreateListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create Your List',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF757575), // Grey text
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              TextField(
                controller: _nameController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Type the Grocery's list",
                  hintStyle: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.blackprimaryapp,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Row(
                  children: [
                    _buildCircleButton(
                      icon: Icons.camera_alt,
                      onTap: () {
                        // Handle camera
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildCircleButton(
                      icon: Icons.send,
                      onTap: () => _validateAndAddItem(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Color(0xFF26AC73), // Vibrant Green
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildVoiceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create Your List buy voice',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF26AC73),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_isListening)
                        BoxShadow(
                          color: const Color(0xFF26AC73).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isListening ? 'Listening...' : 'Tap to Speak',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackprimaryapp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroceryList(List<GroceryItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Grocery List',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackprimaryapp,
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<ProductBloc>().add(const ClearGroceryList());
              },
              child: const Text(
                'Clear all',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return GroceryItemCard(
                item: items[index],
                onUpdate: (updatedItem) {
                  context.read<ProductBloc>().add(
                        UpdateGroceryItem(updatedItem),
                      );
                },
                onDelete: () {
                  context.read<ProductBloc>().add(
                        RemoveGroceryItem(items[index].id),
                      );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool hasItems) {
    return Column(
      children: [
        if (!hasItems)
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to product catalog or show suggestions
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Add Items'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF26AC73),
              side: const BorderSide(color: Color(0xFF26AC73), width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        if (hasItems) ...[
          ElevatedButton(
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26AC73),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // Capture items from current context
              final productState = context.read<ProductBloc>().state;
              final items = productState is ProductLoaded ? productState.groceryItems : <GroceryItem>[];

              // Navigate to Cart Screen with BLoC
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => CheckoutBloc(
                      OrderRepository(OrderService()),
                    )..add(
                        LoadCart(
                          items: items,
                          shopId: widget.shop.name,
                          shopName: widget.shop.name,
                        ),
                      ),
                    child: const CartScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  // Validation method
  void _validateAndAddItem() {
    setState(() {
      _nameError = null;
    });

    final name = _nameController.text.trim();
    bool hasError = false;

    // Validate name
    if (name.isEmpty) {
      setState(() => _nameError = 'Item name is required');
      hasError = true;
    } else if (name.length < 2) {
      setState(() => _nameError = 'Name must be at least 2 characters');
      hasError = true;
    } else if (name.length > 50) {
      setState(() => _nameError = 'Name is too long (max 50 characters)');
      hasError = true;
    }

    if (hasError) {
      return;
    }

    // Check for duplicates
    final state = context.read<ProductBloc>().state;
    if (state is ProductLoaded) {
      final isDuplicate = state.groceryItems.any(
        (item) => item.name.toLowerCase() == name.toLowerCase(),
      );

      if (isDuplicate) {
        setState(() => _nameError = 'This item is already in your list');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"$name" is already in your list'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    // All validations passed - add the item
    context.read<ProductBloc>().add(
      AddGroceryItem(
        name: name,
        quantity: '1', // Default quantity
      ),
    );

    // Clear inputs and show success
    _nameController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$name" added to your list'),
        backgroundColor: Color(0xFF26AC73),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
