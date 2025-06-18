import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';

class TMeasurementHistory extends StatelessWidget {
  const TMeasurementHistory({super.key});

  // Dummy data for saved measurements
  final List<Map<String, String>> savedMeasurements = const [
    {
      'date': '2023-10-01',
      'measurements': 'Chest: 40in, Waist: 32in, Sleeve: 24in',
    },
    {
      'date': '2023-09-25',
      'measurements': 'Chest: 38in, Waist: 30in, Sleeve: 23in',
    },
    {
      'date': '2023-09-10',
      'measurements': 'Chest: 39in, Waist: 31in, Sleeve: 24in',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Measurement History',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by date...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Add search functionality
              },
            ),
            const SizedBox(height: 16),

            // Measurement List
            if (savedMeasurements.isEmpty)
            // Empty State Design
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty_state.png', // Add your empty state illustration
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No measurements saved yet.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality to add a new measurement
                        },
                        child: const Text('Add Measurement'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // Add refresh functionality
                  },
                  child: ListView.builder(
                    itemCount: savedMeasurements.length,
                    itemBuilder: (context, index) {
                      final measurement = savedMeasurements[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: const Icon(Iconsax.rulerpen, color: Colors.blue),
                          title: Text(
                            'Date: ${_formatDate(measurement['date']!)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            'Measurements: ${measurement['measurements']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to format date
  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Measurement'),
          content: const Text('Are you sure you want to delete this measurement?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add functionality to delete the measurement
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}