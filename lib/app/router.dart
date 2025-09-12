import 'package:contact_hub/features/contact/views/add_contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:contact_hub/features/auth/views/login_page.dart';
import 'package:contact_hub/features/auth/views/signup_page.dart';
import 'package:contact_hub/features/contact/views/contact_page.dart';
import 'package:contact_hub/features/contact/provider/contact_provider.dart';
import 'package:contact_hub/features/contact/provider/search_provider.dart';
import 'package:contact_hub/features/contact/provider/theme_provider.dart';
import 'package:contact_hub/data/repo/contact_repository.dart';

class AppRouter {
  AppRouter(this.client);
  final SupabaseClient client;

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/contacts':
        return MaterialPageRoute(
          builder: (_) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) =>
                    ContactsProvider(ContactRepository(client))..load(),
              ),
              ChangeNotifierProvider(create: (_) => SearchProvider()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: const ContactsPage(),
          ),
        );
      case '/add-contact':
        return MaterialPageRoute(builder: (_) => const AddEditContactPage());
      case '/edit-contact':
        return MaterialPageRoute(builder: (_) => const AddEditContactPage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
