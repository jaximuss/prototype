// lib/nav/forum.dart
import 'package:flutter/material.dart';
import 'package:prototype/Models/usermodel.dart';
import 'package:prototype/nav/publicChat.dart';
import 'package:prototype/screens/chatscreen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<UserProfile> _allUsers = [
    UserProfile(name: "Sam Richer", mentalHealthFocus: "Anxiety", daysActive: 20, profilePictureUrl: '' ),
    UserProfile(name: "Racheal Agaro", mentalHealthFocus: "PTSD", daysActive: 10, profilePictureUrl: '' ),
    UserProfile(name: "Francis Esenwar", mentalHealthFocus: "ADHD", daysActive: 22, profilePictureUrl: ''),
    UserProfile(name: "Nonmso Medembem", mentalHealthFocus: "Autism", daysActive: 52, profilePictureUrl: ''),
    UserProfile(name: "Jane Doe", mentalHealthFocus: "Depression", daysActive: 15, profilePictureUrl: ''),
    UserProfile(name: "John Smith", mentalHealthFocus: "Bipolar Disorder", daysActive: 33, profilePictureUrl: '', ),
    UserProfile(name: "Alice Wonderland", mentalHealthFocus: "Burnout", daysActive: 18, profilePictureUrl: ''),
    UserProfile(name: "Bob Builder", mentalHealthFocus: "Stress", daysActive: 27, profilePictureUrl: ''),
    UserProfile(name: "Charlie Chaplin", mentalHealthFocus: "Insomnia", daysActive: 25, profilePictureUrl: ''),
    UserProfile(name: "Diana Prince", mentalHealthFocus: "OCD", daysActive: 30, profilePictureUrl: ''),
  ];

  List<UserProfile> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
    _searchController.addListener(filterUsers);
  }

  void filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        return user.name.toLowerCase().contains(query) ||
            user.mentalHealthFocus.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showOptions(BuildContext context, UserProfile user) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text('View Profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  // Optional: Add profile viewing logic here
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Send Message'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(user: user),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        title: const Text('Mental Health Forum'),
        backgroundColor: dark ? Colors.black : Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search members or topics...',
                prefixIcon: Icon(Icons.search),
                fillColor: dark ? Colors.grey[800] : Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showOptions(context, _filteredUsers[index]),
                  child: ProfileCard(user: _filteredUsers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final UserProfile user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.teal,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  'Focus: ${user.mentalHealthFocus}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: dark ? Colors.grey : Colors.grey[600],
                  ),
                ),
                Text(
                  'Days Active: ${user.daysActive}',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: dark ? Colors.grey : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
