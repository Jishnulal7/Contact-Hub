import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String text;
  final VoidCallback? onAddContact;
  const EmptyState({super.key, required this.text, this.onAddContact});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 56, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
      
          const SizedBox(height: 16),
      
          FilledButton.icon(
            onPressed: onAddContact,
            icon: const Icon(Icons.login),
            label: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }
}
