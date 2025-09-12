import 'package:contact_hub/data/model/contact.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactRepository {
  final SupabaseClient _client;
  ContactRepository(this._client);

  String _requireUserId() {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) {
      throw StateError('Not logged in');
    }
    return uid;
  }

  Future<List<Contact>> fetchContacts({
    String query = '',
    bool? favoritesOnly,
    int limit = 100,
    int offset = 0,
    String sort = 'created_at',
    bool desc = true,
    String? secondarySort,
  }) async {
    final userId = _requireUserId();

    final q = _client.from('contacts').select().eq('user_id', userId);

    // Apply favorites filter
    if (favoritesOnly == true) q.eq('is_favorite', true);

    // Apply search query
    if (query.isNotEmpty) {
      q.or('name.ilike.%$query%,phone.ilike.%$query%');
    }

    // Apply primary sorting
    q.order(sort, ascending: !desc);

    // Apply secondary sorting if specified
    if (secondarySort != null && secondarySort != sort) {
      // For favorites first sorting, we want created_at descending as secondary
      if (sort == 'is_favorite' && secondarySort == 'created_at') {
        q.order(secondarySort, ascending: false);
      } else {
        q.order(secondarySort, ascending: !desc);
      }
    }

    // Apply pagination
    q.range(offset, offset + limit - 1);

    final data = await q;
    return (data as List).map((e) => Contact.fromJson(e)).toList();
  }

  Future<List<Contact>> fetchRecentContacts({
    int limit = 5,
    int daysBack = 7,
  }) async {
    final userId = _requireUserId();
    final cutoffDate = DateTime.now().subtract(Duration(days: daysBack));

    final data = await _client
        .from('contacts')
        .select()
        .eq('user_id', userId)
        .gte('created_at', cutoffDate.toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List).map((e) => Contact.fromJson(e)).toList();
  }

  Future<Contact> createContact(Contact c) async {
    final userId = _requireUserId();
    final res = await _client
        .from('contacts')
        .insert({...c.toInsert(), 'user_id': userId})
        .select()
        .single();
    return Contact.fromJson(res);
  }

  Future<Contact> updateContact(Contact c) async {
    _requireUserId();
    final res = await _client
        .from('contacts')
        .update({'name': c.name, 'phone': c.phone, 'is_favorite': c.isFavorite})
        .eq('id', c.id)
        .select()
        .single();
    return Contact.fromJson(res);
  }

  Future<void> deleteContact(String id) async {
    _requireUserId();
    await _client.from('contacts').delete().eq('id', id);
  }
}
