import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _startExamFlow(BuildContext context) {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            leadingNavBarWidget: const BackButton(),
            trailingNavBarWidget: const CloseButton(),
            topBarTitle: const Text('Step 1: Enter Exam Name'),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(hintText: 'e.g., Midterm 1 2025'),
              ),
            ),
          ),
          WoltModalSheetPage(
            topBarTitle: const Text('Step 2: Enter Subjects'),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Comma separated: Math, English',
                ),
              ),
            ),
          ),
          WoltModalSheetPage(
            topBarTitle: const Text('Step 3: Enter Students'),
            child: const Center(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Comma separated: Jane, John',
                ),
              ),
            ),
          ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Student Marklist")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards with icons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                _IconCard(title: "Exams", icon: Icons.assignment),
                _IconCard(title: "Subjects", icon: Icons.book),
                _IconCard(title: "Students", icon: Icons.people),
                _IconCard(title: "Reports", icon: Icons.bar_chart),
              ],
            ),
            const SizedBox(height: 20),

            // Quick Access
            Text("Quick Access", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _startExamFlow(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Start Exam"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Implement Record Scores Flow
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Record Scores"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Exam List
            Text("Exams", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('exams')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const CircularProgressIndicator();
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  return const Text("No exams yet.");

                return Column(
                  children:
                      snapshot.data!.docs.map((doc) {
                        final examName = doc['examName'];
                        return Card(
                          child: ListTile(
                            title: Text(examName),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Record scores flow here
                              },
                            ),
                          ),
                        );
                      }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),

            // Ads or Info Cards
            Text("Info", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              color: theme.colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text("📝 Tip: You can edit scores after saving them!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _IconCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(title, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
