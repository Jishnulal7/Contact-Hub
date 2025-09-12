import 'package:contact_hub/core/constants.dart';
import 'package:contact_hub/features/contact/provider/contact_provider.dart';
import 'package:contact_hub/features/contact/provider/search_provider.dart';
import 'package:contact_hub/features/contact/provider/theme_provider.dart';
import 'package:contact_hub/features/contact/widgets/contact_list_item.dart';
import 'package:contact_hub/features/contact/widgets/empty_state.dart';
import 'package:contact_hub/features/contact/widgets/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

enum SortOption { newest, oldest, alphabetical, favorites }

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;
  SortOption _currentSort = SortOption.newest;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _scrollController.addListener(_handleScroll);
    _fabAnimationController.forward();
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_showFab) {
        setState(() => _showFab = true);
        _fabAnimationController.forward();
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_showFab) {
        setState(() => _showFab = false);
        _fabAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sort,
                    color: theme.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Sort Contacts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSortOption(
                SortOption.newest,
                Icons.schedule,
                'Recently Added',
                'Show newest contacts first',
                theme,
                isDark,
              ),
              _buildSortOption(
                SortOption.oldest,
                Icons.history,
                'Oldest First',
                'Show oldest contacts first',
                theme,
                isDark,
              ),
              _buildSortOption(
                SortOption.alphabetical,
                Icons.sort_by_alpha,
                'Alphabetical',
                'Sort by name A-Z',
                theme,
                isDark,
              ),
              _buildSortOption(
                SortOption.favorites,
                Icons.favorite,
                'Favorites First',
                'Show favorites at the top',
                theme,
                isDark,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    SortOption option,
    IconData icon,
    String title,
    String subtitle,
    ThemeData theme,
    bool isDark,
  ) {
    final isSelected = _currentSort == option;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected 
          ? theme.primaryColor.withOpacity(0.1)
          : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected 
          ? Border.all(color: theme.primaryColor.withOpacity(0.3))
          : null,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected 
              ? theme.primaryColor.withOpacity(0.2)
              : (isDark ? Colors.grey[800] : Colors.grey[100]),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected 
              ? theme.primaryColor
              : (isDark ? Colors.white70 : Colors.black54),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected 
              ? theme.primaryColor
              : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: theme.primaryColor,
              size: 20,
            )
          : null,
        onTap: () {
          setState(() {
            _currentSort = option;
          });
          context.read<ContactsProvider>().setSortOption(_getSortParams(option));
          Navigator.pop(context);
        },
      ),
    );
  }

  Map<String, dynamic> _getSortParams(SortOption option) {
    switch (option) {
      case SortOption.newest:
        return {'sort': 'created_at', 'desc': true};
      case SortOption.oldest:
        return {'sort': 'created_at', 'desc': false};
      case SortOption.alphabetical:
        return {'sort': 'name', 'desc': false};
      case SortOption.favorites:
        return {'sort': 'is_favorite', 'desc': true, 'secondarySort': 'created_at'};
    }
  }

  String _getSortDisplayText() {
    switch (_currentSort) {
      case SortOption.newest:
        return 'Recently Added';
      case SortOption.oldest:
        return 'Oldest First';
      case SortOption.alphabetical:
        return 'Alphabetical';
      case SortOption.favorites:
        return 'Favorites First';
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = context.watch<ContactsProvider>();
    final search = context.watch<SearchProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.kBlack : AppColor.kWhite,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Contacts',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                  onPressed: () => context.read<ThemeProvider>().toggle(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => _showSignOutDialog(context, contacts),
                ),
              ),
            ],
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SearchHeaderDelegate(
              child: Container(
                color: isDark ? Colors.grey[900] : Colors.grey[50],
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (v) => search.set(v, contacts.setQuery),
                    decoration: InputDecoration(
                      hintText: 'Search contacts...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark ? AppColor.kWhite : AppColor.kBlack,
                        size: 22,
                      ),
                      suffixIcon: search.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.grey[500],
                                size: 20,
                              ),
                              onPressed: () =>
                                  search.set('', contacts.setQuery),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildSortAndCounter(context, contacts)),
          _buildContactsList(context, contacts),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: contacts.favoritesOnly ? 1 : 0,
          selectedItemColor: isDark ? Colors.white : theme.primaryColor,
          unselectedItemColor: isDark ? Colors.grey[400] : AppColor.kBlack,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if ((index == 0 && contacts.favoritesOnly) ||
                (index == 1 && !contacts.favoritesOnly)) {
              contacts.toggleFavoritesOnly();
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.people,
                  color: !contacts.favoritesOnly
                      ? (isDark ? Colors.white : theme.primaryColor)
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
              label: "All Contacts",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.favorite,
                  color: contacts.favoritesOnly
                      ? (isDark ? Colors.white : theme.primaryColor)
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
              label: "Favorites",
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () => Navigator.pushNamed(context, '/add-contact'),
            child: const Icon(Icons.person_add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildSortAndCounter(
    BuildContext context,
    ContactsProvider contacts,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (contacts.loading) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Sort Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: _showSortOptions,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.sort,
                      color: isDark ? AppColor.kWhite : AppColor.kPurple,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sort by: ${_getSortDisplayText()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColor.kWhite : AppColor.kPurple,
                          ),
                        ),
                        if (_currentSort == SortOption.newest)
                          Text(
                            'Showing most recent contacts',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Counter
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    contacts.favoritesOnly ? Icons.favorite : Icons.people,
                    color: isDark ? AppColor.kWhite : AppColor.kPurple,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${contacts.items.length} ${contacts.favoritesOnly ? 'favorite' : 'contact'}${contacts.items.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.kWhite : AppColor.kPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList(BuildContext context, ContactsProvider contacts) {
    if (contacts.loading) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Loading contacts...',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (contacts.error.isNotEmpty) {
      return SliverFillRemaining(
        child: ErrorView(message: contacts.error, onRetry: contacts.refresh),
      );
    }

    if (contacts.items.isEmpty) {
      return SliverFillRemaining(
        child: EmptyState(text: 'No contacts found', onAddContact: () {}),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final contact = contacts.items[index];
        final isRecent = _currentSort == SortOption.newest && index < 3;
        
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOutBack,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isRecent 
                ? Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 1.5,
                  )
                : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                ContactListItem(contact: contact),
                if (isRecent)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fiber_new,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }, childCount: contacts.items.length),
    );
  }

  void _showSignOutDialog(BuildContext context, ContactsProvider contacts) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              contacts.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}