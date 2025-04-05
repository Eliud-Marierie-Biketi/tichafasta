import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  // Function to show a modal with quick actions
  void _showModal(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to show advertisement cards
  Widget _buildAdCard(
    String size,
    Color color,
    String title,
    String description,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick Access Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:
                        () => _showModal(
                          context,
                          'Quick Access',
                          'Action 1 executed',
                        ),
                    child: Text('Action 1'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => _showModal(
                          context,
                          'Quick Access',
                          'Action 2 executed',
                        ),
                    child: Text('Action 2'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => _showModal(
                          context,
                          'Quick Access',
                          'Action 3 executed',
                        ),
                    child: Text('Action 3'),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Advertisement Cards (Small, Medium, and Large)
              Text(
                'Advertisements',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Small Ad Card
              _buildAdCard(
                'small',
                Colors.blue,
                'Small Ad',
                'This is a small advertisement card for a quick ad.',
              ),
              // Medium Ad Card
              _buildAdCard(
                'medium',
                Colors.orange,
                'Medium Ad',
                'This is a medium advertisement card for a promotional message.',
              ),
              // Large Ad Card
              _buildAdCard(
                'large',
                Colors.green,
                'Large Ad',
                'This is a large advertisement card with a more detailed description and important information.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
