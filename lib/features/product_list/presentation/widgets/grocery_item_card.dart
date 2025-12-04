import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/product_model.dart';

class GroceryItemCard extends StatefulWidget {
  final GroceryItem item;
  final Function(GroceryItem) onUpdate;
  final VoidCallback onDelete;

  const GroceryItemCard({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends State<GroceryItemCard> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  
  // Validation errors
  String? _nameError;
  String? _quantityError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _nameError = null;
      _quantityError = null;
    });

    final name = _nameController.text.trim();
    final quantity = _quantityController.text.trim();
    bool hasError = false;

    // Validate name
    if (name.isEmpty) {
      setState(() => _nameError = 'Required');
      hasError = true;
    } else if (name.length < 2) {
      setState(() => _nameError = 'Too short');
      hasError = true;
    } else if (name.length > 50) {
      setState(() => _nameError = 'Too long');
      hasError = true;
    } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(name)) {
      setState(() => _nameError = 'Invalid characters');
      hasError = true;
    }

    // Validate quantity
    if (quantity.isEmpty) {
      setState(() => _quantityError = 'Required');
      hasError = true;
    } else if (quantity.length > 20) {
      setState(() => _quantityError = 'Too long');
      hasError = true;
    }

    if (hasError) {
      return;
    }

    // All validations passed
    widget.onUpdate(
      widget.item.copyWith(
        name: name,
        quantity: quantity,
      ),
    );
    setState(() => _isEditing = false);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$name" updated'),
        backgroundColor: const Color(0xFF26AC73),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _isEditing ? _buildEditMode() : _buildViewMode(),
    );
  }

  Widget _buildViewMode() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            widget.item.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.blackprimaryapp,
            ),
          ),
        ),
        Expanded(
          child: Text(
            widget.item.quantity + (widget.item.unit != null ? ' ${widget.item.unit}' : ''),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.blacksecondaryapp,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() => _isEditing = true);
          },
          icon: const Icon(
            Icons.edit,
            color: Color(0xFF26AC73),
            size: 20,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _nameController,
                onChanged: (value) {
                  if (_nameError != null) {
                    setState(() => _nameError = null);
                  }
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Name',
                  errorText: _nameError,
                  errorStyle: const TextStyle(fontSize: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _nameError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _nameError != null ? Colors.red : const Color(0xFF26AC73),
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _quantityController,
                onChanged: (value) {
                  if (_quantityError != null) {
                    setState(() => _quantityError = null);
                  }
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Qty',
                  errorText: _quantityError,
                  errorStyle: const TextStyle(fontSize: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _quantityError != null ? Colors.red : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _quantityError != null ? Colors.red : const Color(0xFF26AC73),
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    _nameController.text = widget.item.name;
                    _quantityController.text = widget.item.quantity;
                    setState(() => _isEditing = false);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _confirmDelete(),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26AC73),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Confirm delete with dialog
  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to remove "${widget.item.name}" from your list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      widget.onDelete();
    }
  }
}
