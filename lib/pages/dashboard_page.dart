import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _showStartExamModal(BuildContext context) {
    WoltModalSheet.show<void>(
      context: context,
      modalTypeBuilder: (context) {
        return WoltModalType.dialog(); // Centered modal type
      },
      pageListBuilder: (modalContext) {
        final textTheme = Theme.of(modalContext).textTheme;

        return [
          // Page 1: Exam Info
          WoltModalSheetPage(
            topBarTitle: Text('Exam Info', style: textTheme.titleLarge),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Exam Name'),
                  ),
                  TextField(decoration: InputDecoration(labelText: 'Date')),
                ],
              ),
            ),
            stickyActionBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: WoltModalSheet.of(modalContext).showNext,
                child: const Text('Next: Subjects'),
              ),
            ),
          ),

          // Page 2: Select Subjects
          WoltModalSheetPage(
            topBarTitle: Text('Select Subjects', style: textTheme.titleLarge),
            child: SingleChildScrollView(
              // Using SingleChildScrollView for long lists
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text('Math'),
                    value: true,
                    onChanged: (_) {},
                  ),
                  CheckboxListTile(
                    title: Text('Science'),
                    value: false,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
            stickyActionBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: WoltModalSheet.of(modalContext).showNext,
                child: const Text('Next: Students'),
              ),
            ),
          ),

          // Page 3: Students
          WoltModalSheetPage(
            topBarTitle: Text(
              'Enter Student Scores',
              style: textTheme.titleLarge,
            ),
            child: SingleChildScrollView(
              // Make the student list scrollable
              child: Column(
                children: List.generate(10, (index) {
                  return ListTile(
                    title: Text('Student ${index + 1}'),
                    subtitle: TextField(
                      decoration: InputDecoration(labelText: 'Score'),
                      keyboardType: TextInputType.number,
                    ),
                  );
                }),
              ),
            ),
            stickyActionBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(modalContext).pop();
                  // Submit Logic
                },
                child: const Text('Submit & Finish'),
              ),
            ),
          ),
        ];
      },
    );
  }

  void _showRecordScoresModal(BuildContext context, String examName) {
    WoltModalSheet.show<void>(
      context: context,
      modalTypeBuilder: (context) {
        return WoltModalType.dialog(); // Centered modal type
      },
      pageListBuilder: (modalContext) {
        final textTheme = Theme.of(modalContext).textTheme;

        return [
          // Page 1: Choose Subject
          WoltModalSheetPage(
            topBarTitle: Text(
              'Subjects in $examName',
              style: textTheme.titleLarge,
            ),
            child: SingleChildScrollView(
              // Added SingleChildScrollView to make it scrollable
              child: Column(
                children: [
                  ListTile(
                    title: Text('Math'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: WoltModalSheet.of(modalContext).showNext,
                  ),
                  ListTile(
                    title: Text('English'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: WoltModalSheet.of(modalContext).showNext,
                  ),
                ],
              ),
            ),
          ),

          // Page 2: Student Score Input
          WoltModalSheetPage(
            topBarTitle: Text(
              'Math - Enter Scores',
              style: textTheme.titleLarge,
            ),
            child: SingleChildScrollView(
              // Make the student list scrollable
              child: Column(
                children: List.generate(10, (index) {
                  return ListTile(
                    title: Text('Student ${index + 1}'),
                    subtitle: TextField(
                      decoration: InputDecoration(labelText: 'Score'),
                      keyboardType: TextInputType.number,
                    ),
                  );
                }),
              ),
            ),
            stickyActionBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(modalContext).pop();
                  // Handle submit
                },
                child: const Text('Submit Scores'),
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
                  onPressed: () => _showStartExamModal(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Start Exam"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showRecordScoresModal(context, "Exam Name"),
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
