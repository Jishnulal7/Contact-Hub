// import 'package:contact_hub/data/model/contact.dart';
// import 'package:contact_hub/data/repo/contact_repository.dart';
// import 'package:contact_hub/features/auth/provider/auth_provider.dart';
// import 'package:contact_hub/features/auth/views/login_page.dart';
// import 'package:contact_hub/features/auth/views/signup_page.dart';
// import 'package:contact_hub/features/contact/provider/contact_provider.dart';
// import 'package:contact_hub/features/contact/provider/search_provider.dart';
// import 'package:contact_hub/features/contact/provider/theme_provider.dart';
// import 'package:contact_hub/features/contact/views/add_contact.dart';
// import 'package:contact_hub/features/contact/views/contact_page.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key, required this.client});

//   final SupabaseClient client;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, auth, child) {
//         if (auth.loading && auth.user == null) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (auth.isAuthenticated) {
//           return MultiProvider(
//             providers: [
//               ChangeNotifierProvider(
//                 create: (_) =>
//                     ContactsProvider(ContactRepository(client))..load(),
//               ),
//               ChangeNotifierProvider(create: (_) => SearchProvider()),
//               ChangeNotifierProvider(create: (_) => ThemeProvider()),
//             ],
//             // Use Builder to provide the correct context
//             child: Builder(
//               builder: (context) => Navigator(
//                 onGenerateRoute: (settings) {
//                   switch (settings.name) {
//                     case '/add-contact':
//                       return MaterialPageRoute(
//                         builder: (context) => const AddEditContactPage(),
//                       );
//                     case '/edit-contact':
//                       final contact = settings.arguments as Contact?;
//                       return MaterialPageRoute(
//                         builder: (context) => AddEditContactPage(existing: contact),
//                       );
//                     default:
//                       return MaterialPageRoute(
//                         builder: (context) => const ContactsPage(),
//                       );
//                   }
//                 },
//               ),
//             ),
//           );
//         }

//         return Navigator(
//           onGenerateRoute: (settings) {
//             switch (settings.name) {
//               case '/signup':
//                 return MaterialPageRoute(builder: (_) => const SignupPage());
//               default:
//                 return MaterialPageRoute(builder: (_) => const LoginPage());
//             }
//           },
//         );
//       },
//     );
//   }
// }