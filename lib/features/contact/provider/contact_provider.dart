import 'package:contact_hub/data/model/contact.dart';
import 'package:contact_hub/data/repo/auth_repository.dart';
import 'package:contact_hub/data/repo/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactsProvider extends ChangeNotifier {
  final ContactRepository repo;
  ContactsProvider(this.repo);

  List<Contact> _items = [];
  bool _loading = false;
  String _error = '';
  String _query = '';
  bool _favoritesOnly = false;

  String _sortField = 'created_at';
  bool _sortDescending = true;
  String? _secondarySortField;

  List<Contact> get items => _items;
  bool get loading => _loading;
  String get error => _error;
  bool get favoritesOnly => _favoritesOnly;
  String get sortField => _sortField;
  bool get sortDescending => _sortDescending;
  
  Future<void> load({bool refresh = false}) async {
    _loading = true;
    _error = '';
    notifyListeners();
    try {
      _items = await repo.fetchContacts(
        query: _query,
        favoritesOnly: _favoritesOnly,
        sort: _sortField,
        desc: _sortDescending,
        secondarySort: _secondarySortField,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setQuery(String q) {
    _query = q;
    load();
  }

  void toggleFavoritesOnly() {
    _favoritesOnly = !_favoritesOnly;
    load();
  }

  Future<void> add(Contact c) async {
    final temp = c;
    _items = [temp, ..._items];
    notifyListeners();
    try {
      final saved = await repo.createContact(c);
      _items = [saved, ..._items.where((x) => x.id != temp.id)];
    } catch (_) {
      await refresh();
    }
    notifyListeners();
  }

  Future<void> update(Contact c) async {
    final idx = _items.indexWhere((x) => x.id == c.id);
    if (idx == -1) return;
    final prev = _items[idx];
    _items[idx] = c;
    notifyListeners();
    try {
      _items[idx] = await repo.updateContact(c);
    } catch (_) {
      _items[idx] = prev;
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    final prev = _items;
    _items = _items.where((x) => x.id != id).toList();
    notifyListeners();
    try {
      await repo.deleteContact(id);
    } catch (_) {
      _items = prev;
      notifyListeners();
    }
  }

  Future<void> refresh() => load(refresh: true);
  void signOut() {
    final client = Supabase.instance.client;
    AuthRepository authRepository = AuthRepository(client);
    authRepository.signout();
  }

  void setSortOption(Map<String, dynamic> sortParams) {
    _sortField = sortParams['sort'] ?? 'created_at';
    _sortDescending = sortParams['desc'] ?? true;
    _secondarySortField = sortParams['secondarySort'];
    load();
  }

  void sortByRecentlyAdded() {
    setSortOption({'sort': 'created_at', 'desc': true});
  }

  // Helper method to sort by oldest first
  void sortByOldest() {
    setSortOption({'sort': 'created_at', 'desc': false});
  }

  // Helper method to sort alphabetically
  void sortAlphabetically() {
    setSortOption({'sort': 'name', 'desc': false});
  }

  // Helper method to sort favorites first
  void sortByFavoritesFirst() {
    setSortOption({
      'sort': 'is_favorite',
      'desc': true,
      'secondarySort': 'created_at',
    });
  }
}
