import 'package:flutter/material.dart';
import 'graph_screen.dart';
import './seller_list_screen.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const CottonQualityDataScreen(),
    GraphScreen(),
    const SellerListScreen(), // Only 3 items now
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFFDC),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Quality',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Graph'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sellers'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CottonQualityDataScreen extends StatelessWidget {
  const CottonQualityDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: 'Dashboard'),
          const SizedBox(height: 8.0),
          const _GreetingText(text: 'Hello Ghulam Ali 👋,'),
          const SizedBox(height: 20.0),
          _buildQualityCards(),
          const SizedBox(height: 20.0),
          const _SectionTitle(title: 'Total Quantity and Quality'),
          const SizedBox(height: 8.0),
          const _SectionSubtitle(
            text: 'List of the province with respect to quality and quantity',
          ),
          const SizedBox(height: 12.0),
          _buildDataTable(),
        ],
      ),
    );
  }

  Widget _buildQualityCards() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _DistrictQualityCard(district: 'Sukkur', quality: 80),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _DistrictQualityCard(district: 'Khairpur', quality: 70),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: _DistrictQualityCard(district: 'Mirpurkhas', quality: 60),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _DistrictQualityCard(district: 'Badin', quality: 59),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return Column(
      children: const [
        _DataTableHeader(),
        _DataTableRow(district: 'Badin', quantity: 1500, quality: 15),
        _DataTableRow(district: 'Mirpurkhas', quantity: 1600, quality: 10),
        _DataTableRow(district: 'Khairpur', quantity: 1600, quality: 6),
        _DataTableRow(district: 'Sukkur', quantity: 1600, quality: 5),
        _DataTableRow(district: 'Shikarpur', quantity: 1600, quality: 4),
        _DataTableRow(district: 'Badin', quantity: 1600, quality: 20),
        _DataTableRow(district: 'Thatha', quantity: 1600, quality: 4),
        _DataTableRow(district: 'Hyderabad', quantity: 1600, quality: 6),
        _DataTableRow(district: 'Sanghar', quantity: 1600, quality: 20),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  final String text;

  const _GreetingText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18.0, color: Colors.black87),
    );
  }
}

class _DistrictQualityCard extends StatelessWidget {
  final String district;
  final int quality;

  const _DistrictQualityCard({required this.district, required this.quality});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$quality%',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            district,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _SectionSubtitle extends StatelessWidget {
  final String text;

  const _SectionSubtitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black54, fontSize: 14),
    );
  }
}

class _DataTableHeader extends StatelessWidget {
  const _DataTableHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 24),
          Expanded(
            child: Text(
              'Province',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Weight in KG',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Quality',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataTableRow extends StatelessWidget {
  final String district;
  final int quantity;
  final int quality;

  const _DataTableRow({
    required this.district,
    required this.quantity,
    required this.quality,
  });

  Color get _indicatorColor {
    switch (district.toLowerCase()) {
      case 'badin':
        return Colors.pink;
      case 'mirpurkhas':
        return Colors.green;
      case 'khairpur':
        return Colors.yellow;
      case 'sukkur':
        return Colors.purple;
      case 'shikarpur':
        return Colors.indigo;
      case 'thatha':
        return Colors.cyan;
      case 'hyderabad':
        return Colors.orange;
      case 'sanghar':
        return Colors.lime;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: _indicatorColor, radius: 8),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              district,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              '$quantity kg',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              '$quality%',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

/*
// 📁 lib/screens/buyer/buyer_dashboard_screen.dart
// ✅ Purpose: Buyer can view all available crops uploaded by farmers.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyerDashboardScreen extends StatelessWidget {
  const BuyerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Crops')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('crops')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final crops = snapshot.data!.docs;

          if (crops.isEmpty) {
            return const Center(child: Text('No crops available.'));
          }

          return ListView.builder(
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final crop = crops[index].data() as Map<String, dynamic>;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 4,
                child: ListTile(
                  title: Text(crop['crop'] ?? 'Unknown Crop'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${crop['quantity']}'),
                      Text('Price: ${crop['price']}'),
                      Text('Farmer ID: ${crop['uid']}'),
                    ],
                  ),
                  trailing: const Icon(Icons.agriculture),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/
