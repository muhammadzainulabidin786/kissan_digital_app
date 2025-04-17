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
