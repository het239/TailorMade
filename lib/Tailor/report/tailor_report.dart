import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For charts

class TailorReportScreen extends StatelessWidget {
  const TailorReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example data for charts
    final List<ChartData> chartData = [
      ChartData('Completed', 35, Colors.green),
      ChartData('Pending', 15, Colors.orange),
      ChartData('Cancelled', 5, Colors.red),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tailor Report'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Overview
            Text(
              'Order Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildStatCard(context, 'Total Orders', '50', Colors.blue),
                _buildStatCard(context, 'Completed Orders', '35', Colors.green),
                _buildStatCard(context, 'Pending Orders', '15', Colors.orange),
                _buildStatCard(context, 'Revenue', '\₹1200', Colors.amberAccent),
              ],
            ),
            const SizedBox(height: 24),

            // Pie Chart for Order Status
            Text(
              'Order Status Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 300,
              child: SfCircularChart(
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.status,
                    yValueMapper: (ChartData data, _) => data.value,
                    pointColorMapper: (ChartData data, _) => data.color,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Orders Table
            Text(
              'Recent Orders',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order #')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Amount')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('001')),
                    DataCell(Text('John Doe')),
                    DataCell(Text('Completed', style: TextStyle(color: Colors.green))),
                    DataCell(Text('\₹120')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('002')),
                    DataCell(Text('Jane Smith')),
                    DataCell(Text('Pending', style: TextStyle(color: Colors.orange))),
                    DataCell(Text('\₹80')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('003')),
                    DataCell(Text('Alice Johnson')),
                    DataCell(Text('Cancelled', style: TextStyle(color: Colors.red))),
                    DataCell(Text('\₹60')),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Refresh Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Refresh data logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Refresh Data',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build statistic cards
  Widget _buildStatCard(BuildContext context, String title, String value, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width / 2) - 24, // Adjust width based on screen size
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withAlpha(51), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model for chart
class ChartData {
  final String status;
  final int value;
  final Color color;

  ChartData(this.status, this.value, this.color);
}