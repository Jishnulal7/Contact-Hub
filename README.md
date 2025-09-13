# 📱 Contact Hub

A modern, feature-rich contact management application built with Flutter and Supabase. Contact Hub provides a seamless experience for managing your personal and professional contacts with advanced sorting, search, and organization features.

## ✨ Features

- **🔐 User Authentication** - Secure sign-up and sign-in with Supabase Auth
- **📋 Contact Management** - Create, read, update, and delete contacts
- **⭐ Favorites System** - Mark important contacts as favorites
- **🔍 Advanced Search** - Search contacts by name or phone number
- **📊 Smart Sorting** - Multiple sorting options:
  - Recently Added (newest first)
  - Oldest First
  - Alphabetical (A-Z)
  - Favorites First
- **🆕 Recently Added Section** - Highlight newly added contacts
- **🌙 Dark Mode** - Beautiful dark and light theme support
- **📱 Responsive Design** - Optimized for mobile devices
- **🔄 Real-time Sync** - Cloud-based storage with Supabase
- **⚡ Optimistic Updates** - Instant UI updates with error handling

- **Provider Pattern** - State management using Flutter Provider
- **Repository Pattern** - Data layer abstraction
- **Supabase Integration** - Backend-as-a-Service for database and auth

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Supabase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/contact_hub.git
   cd contact_hub
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create a new project at [supabase.com](https://supabase.com)
   - Create the following table in your Supabase database:

   ```sql
   CREATE TABLE contacts (
     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
     user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
     name TEXT NOT NULL,
     phone TEXT NOT NULL,
     is_favorite BOOLEAN DEFAULT FALSE,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   -- Enable Row Level Security
   ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

   -- Create policies
   CREATE POLICY "Users can only see their own contacts" ON contacts
     FOR SELECT USING (auth.uid() = user_id);

   CREATE POLICY "Users can insert their own contacts" ON contacts
     FOR INSERT WITH CHECK (auth.uid() = user_id);

   CREATE POLICY "Users can update their own contacts" ON contacts
     FOR UPDATE USING (auth.uid() = user_id);

   CREATE POLICY "Users can delete their own contacts" ON contacts
     FOR DELETE USING (auth.uid() = user_id);

   -- Create indexes for better performance
   CREATE INDEX idx_contacts_user_id ON contacts(user_id);
   CREATE INDEX idx_contacts_created_at ON contacts(created_at);
   CREATE INDEX idx_contacts_name ON contacts(name);
   ```

4. **Configure Supabase**
   - Create a file `lib/core/supabase_config.dart`:
   ```dart
   class SupabaseConfig {
     static const String url = 'YOUR_SUPABASE_URL';
     static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```

5. **Run the app**
   ```bash
   flutter run
   ```
   

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Supabase** - Backend-as-a-Service
- **Provider** - State management
- **Material Design** - UI components

## 🔧 Configuration

### Supabase Setup
1. Create tables with proper RLS policies
2. Set up authentication providers (email/password)
3. Configure environment variables
4. Enable real-time subscriptions (optional)

### App Configuration
- Update `SupabaseConfig` with your credentials
- Customize `AppColor` constants in `core/constants.dart`
- Modify app name and package in `pubspec.yaml`

## 📱 Screenshots
https://github.com/Jishnulal7/Contact-Hub/blob/a8b04f104c58ad1192134949bedbc278674b340b/photo_2025-09-13_10-47-39.jpg
https://github.com/Jishnulal7/Contact-Hub/blob/a8b04f104c58ad1192134949bedbc278674b340b/photo_2025-09-13_10-47-40.jpg
https://github.com/Jishnulal7/Contact-Hub/blob/a8b04f104c58ad1192134949bedbc278674b340b/photo_2025-09-13_10-47-42.jpg
https://github.com/Jishnulal7/Contact-Hub/blob/a8b04f104c58ad1192134949bedbc278674b340b/photo_2025-09-13_10-47-43.jpg
https://github.com/Jishnulal7/Contact-Hub/blob/a8b04f104c58ad1192134949bedbc278674b340b/photo_2025-09-13_10-47-44.jpg
https://github.com/Jishnulal7/Contact-Hub/blob/a8b04f104c58ad1192134949bedbc278674b340b/photo_2025-09-13_10-47-46.jpg

