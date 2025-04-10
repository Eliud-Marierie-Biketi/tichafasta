import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({super.key});

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool expanded = true;
  int selected = 0;

  shadcn.NavigationItem buildButton(String text, IconData icon) {
    return shadcn.NavigationItem(
      label: Text(text),
      alignment: Alignment.topLeft,
      child: Icon(icon),
    );
  }

  shadcn.NavigationLabel buildLabel(String label) {
    return shadcn.NavigationLabel(
      alignment: Alignment.topLeft,
      child: Text(label).semiBold().muted(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      width: 260,
      height: double.infinity,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // Sidebar Navigation
          Expanded(
            child: shadcn.NavigationRail(
              backgroundColor: theme.colorScheme.surface,
              labelType: shadcn.NavigationLabelType.expanded,
              labelPosition: shadcn.NavigationLabelPosition.end,
              alignment: shadcn.NavigationRailAlignment.start,
              expanded: expanded,
              index: selected,
              onSelected: (value) {
                setState(() {
                  selected = value;
                });
              },
              children: [
                shadcn.NavigationButton(
                  alignment: Alignment.topLeft,
                  label: const Text('Menu'),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  child: const Icon(Icons.menu),
                ),
                const shadcn.NavigationDivider(),
                buildLabel('Main'),
                buildButton('Home', Icons.home_filled),
                buildButton('Trending', Icons.trending_up),
                buildButton('Subscription', Icons.subscriptions),
                const shadcn.NavigationDivider(),
                buildLabel('Exams'),
                buildButton('History', Icons.history),
                buildButton('Watch Later', Icons.access_time_rounded),
                const shadcn.NavigationDivider(),
                buildLabel('User Settings'),
                buildButton('Action', Icons.movie_creation_outlined),
                buildButton('Horror', Icons.movie_creation_outlined),
                buildButton('Thriller', Icons.movie_creation_outlined),
              ],
            ),
          ),

          // Profile at the bottom
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage('assets/profile.png')
                              as ImageProvider,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 10),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    user?.displayName ?? 'Guest',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // Navigate to ProfilePage
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
