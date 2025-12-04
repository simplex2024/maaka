import 'package:flutter/material.dart';

class ModuleSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Color themeColor;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onMicTap;

  const ModuleSearchBar({
    super.key,
    required this.controller,
    required this.themeColor,
    this.hintText = 'Search Shop',
    this.onChanged,
    this.onSubmitted,
    this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
            ),
          ),
          Container(
            height: 24,
            width: 1,
            color: Colors.white.withOpacity(0.5),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.white),
            onPressed: onMicTap,
          ),
        ],
      ),
    );
  }
}
