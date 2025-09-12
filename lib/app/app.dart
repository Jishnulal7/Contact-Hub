import 'package:contact_hub/app/theme.dart';
import 'package:contact_hub/data/repo/auth_repository.dart';
import 'package:contact_hub/data/repo/contact_repository.dart';
import 'package:contact_hub/features/auth/provider/auth_provider.dart';
import 'package:contact_hub/features/auth/views/login_page.dart';
import 'package:contact_hub/features/auth/views/signup_page.dart';
import 'package:contact_hub/features/contact/provider/contact_provider.dart';
import 'package:contact_hub/features/contact/provider/search_provider.dart';
import 'package:contact_hub/features/contact/provider/theme_provider.dart';
import 'package:contact_hub/features/contact/views/add_contact.dart';
import 'package:contact_hub/features/contact/views/contact_page.dart';
import 'package:contact_hub/data/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepository(client)),
        ),
        ChangeNotifierProvider(
          create: (_) => ContactsProvider(ContactRepository(client)),
        ),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, theme, auth, child) {
          if (auth.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ContactsProvider>().load();
            });
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: theme.themeMode,
            theme: lightTheme(),
            darkTheme: darkTheme(),
            home: _getHomePage(auth),
            onGenerateRoute: (settings) => _generateRoute(settings, auth),
          );
        },
      ),
    );
  }

  Widget _getHomePage(AuthProvider auth) {
    if (auth.loading && auth.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (auth.isAuthenticated) {
      return const ContactsPage();
    }

    return const LoginPage();
  }

  Route<dynamic>? _generateRoute(RouteSettings settings, AuthProvider auth) {
    if (!auth.isAuthenticated) {
      switch (settings.name) {
        case '/signup':
          return MaterialPageRoute(builder: (_) => const SignupPage());
        case '/login':
        default:
          return MaterialPageRoute(builder: (_) => const LoginPage());
      }
    }

    // Authenticated routes
    switch (settings.name) {
      case '/contacts':
        return MaterialPageRoute(builder: (_) => const ContactsPage());
      case '/add-contact':
        return MaterialPageRoute(builder: (_) => const AddEditContactPage());
      case '/edit-contact':
        final contact = settings.arguments as Contact?;
        return MaterialPageRoute(
          builder: (_) => AddEditContactPage(existing: contact),
        );
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => const ContactsPage());
    }
  }
}
