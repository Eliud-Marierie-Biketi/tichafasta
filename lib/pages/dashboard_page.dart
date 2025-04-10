import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int index = 0;
  final shadcn.CarouselController controller = shadcn.CarouselController();

  void _startExamFlow(BuildContext context) {
    WoltModalSheet.show(
      context: context,
      pageListBuilder:
          (context) => [
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
                  decoration: InputDecoration(hintText: 'Math, English'),
                ),
              ),
            ),
            WoltModalSheetPage(
              topBarTitle: const Text('Step 3: Enter Students'),
              child: const Center(
                child: TextField(
                  decoration: InputDecoration(hintText: 'Jane, John'),
                ),
              ),
            ),
          ],
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
            // 🚀 Tab Navigation
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    onTap: (value) => setState(() => index = value),
                    tabs: const [
                      Tab(text: 'Dashboard'),
                      Tab(text: 'Carousel'),
                      Tab(text: 'Cards'),
                    ],
                  ),
                ],
              ),
            ),
            const shadcn.Gap(16),
            IndexedStack(
              index: index,
              children: [
                _dashboardSection(context, theme),
                _carouselSection(),
                _cardImageSection(),
              ],
            ).sized(height: 500),
          ],
        ),
      ),
    );
  }

  Widget _dashboardSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 💠 Icon Grid
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

        Text("Quick Access", style: theme.textTheme.titleLarge),
        const shadcn.Gap(8),

        Wrap(
          spacing: 12,
          children: [
            shadcn.PrimaryButton(
              onPressed: () => _startExamFlow(context),
              child: const Text("Start Exam"),
            ),
            shadcn.PrimaryButton(
              onPressed: () {
                // Record Scores logic
              },
              child: const Text("Record Scores"),
            ),
            Tooltip(
              message: 'Start an exam with a few easy steps',
              child: shadcn.PrimaryButton(
                onPressed: () {},
                child: const Text('Hover over me'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Text("Exams", style: theme.textTheme.titleLarge),
        const shadcn.Gap(8),

        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('exams')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("No exams yet.");
            }

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
                            // Score edit
                          },
                        ),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
        const SizedBox(height: 20),

        Text("Info", style: theme.textTheme.titleLarge),
        const shadcn.Gap(8),

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
    );
  }

  // 🎠 Carousel Section
  Widget _carouselSection() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: shadcn.Carousel(
              transition: const shadcn.CarouselTransition.fading(),
              controller: controller,
              draggable: false,
              autoplaySpeed: const Duration(seconds: 2),
              itemCount: 5,
              itemBuilder: (context, index) => NumberedContainer(index: index),
              duration: const Duration(milliseconds: 800),
            ),
          ),
          const shadcn.Gap(8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              shadcn.CarouselDotIndicator(itemCount: 5, controller: controller),
              const Spacer(),
              shadcn.OutlineButton(
                shape: shadcn.ButtonShape.circle,
                onPressed:
                    () => controller.animatePrevious(
                      const Duration(milliseconds: 500),
                    ),
                child: const Icon(Icons.arrow_back),
              ),
              const shadcn.Gap(8),
              shadcn.OutlineButton(
                shape: shadcn.ButtonShape.circle,
                onPressed:
                    () => controller.animateNext(
                      const Duration(milliseconds: 500),
                    ),
                child: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🖼️ Card Image Scroll Section
  Widget _cardImageSection() {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < 10; i++)
                shadcn.CardImage(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Card Image'),
                            content: const Text('You clicked on a card image.'),
                            actions: [
                              shadcn.PrimaryButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                    );
                  },
                  image: Image.network('https://picsum.photos/200/300'),
                  title: Text('Card ${i + 1}'),
                  subtitle: const Text('Sample description'),
                ),
            ],
          ).gap(8),
        ),
      ),
    );
  }
}

// 🧱 NumberedContainer Widget
class NumberedContainer extends StatelessWidget {
  final int index;

  const NumberedContainer({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.primaries[index % Colors.primaries.length],
      child: Text(
        'Item $index',
        style: const TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}

// 🧱 IconCard Widget
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
