import 'package:contact_hub/data/model/contact.dart';
import 'package:contact_hub/features/contact/provider/contact_provider.dart';
import 'package:contact_hub/features/contact/views/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  const ContactListItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ContactsProvider>();

    return Slidable(
      key: ValueKey(contact.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            icon: contact.isFavorite ? Icons.star_outline : Icons.star,
            label: contact.isFavorite ? 'Unfavorite' : 'Favorite',
            onPressed: (_) => provider.update(contact.copyWith(isFavorite: !contact.isFavorite)),
          ),
          SlidableAction(
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Colors.red,
            onPressed: (_) => provider.remove(contact.id),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(child: Text(_initials(contact.name))),
        title: Text(contact.name),
        subtitle: Text(contact.phone),
        trailing: contact.isFavorite ? const Icon(Icons.star, color: Colors.amber) : null,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEditContactPage(existing: contact)),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }
}
