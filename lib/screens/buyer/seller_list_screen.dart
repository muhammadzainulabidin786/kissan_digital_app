import 'package:flutter/material.dart';

class SellerListScreen extends StatelessWidget {
  const SellerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Sukkur', // Keeping the static location in the app bar
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.group, color: Colors.green),
                  const SizedBox(width: 4.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Sellers',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      Text(
                        '1,893',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.desktop_windows, color: Colors.green),
                  const SizedBox(width: 4.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Quality',
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                      Text(
                        '83%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFE2F7E5),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Sellers',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      width: 150.0,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Short by: ',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Newest',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: const [
                Expanded(
                  flex: 3, // Increased flex to accommodate removed city
                  child: Text(
                    'Customer Name',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
                Expanded(
                  flex: 2, // Adjusted flex
                  child: Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
                Expanded(
                  flex: 4, // Increased flex
                  child: Text(
                    'Address',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Quality',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _sellerData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _SellerListItem(
                        customerName: _sellerData[index]['name']!,
                        phoneNumber: _sellerData[index]['phone']!,
                        address: _sellerData[index]['address']!,
                        quality: _sellerData[index]['quality']!,
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing data 1 to ${_sellerData.length}\nof 200 entries',
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.green.shade100,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    const Text(
                      '2',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    const SizedBox(width: 4.0),
                    const Text(
                      '3',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    const SizedBox(width: 4.0),
                    const Text(
                      '4-',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16.0,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      '13',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SellerListItem extends StatelessWidget {
  final String customerName;
  final String phoneNumber;
  final String address;
  final String quality;

  const _SellerListItem({
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.quality,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3, // Increased flex
            child: Text(customerName, style: const TextStyle(fontSize: 14.0)),
          ),
          Expanded(
            flex: 2, // Adjusted flex
            child: Text(phoneNumber, style: const TextStyle(fontSize: 14.0)),
          ),
          Expanded(
            flex: 4, // Increased flex
            child: Text(address, style: const TextStyle(fontSize: 14.0)),
          ),
          Expanded(
            flex: 1,
            child: Text(quality, style: const TextStyle(fontSize: 14.0)),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> _sellerData = [
  {
    'name': 'Muhammad Ali',
    'phone': '03001234567',
    'address': 'Goth dadu',
    'quality': '85%',
  },
  {
    'name': 'Zahid Khan',
    'phone': '03112345678',
    'address': 'Gul stop',
    'quality': '92%',
  },
  {
    'name': 'Ahmed Raza',
    'phone': '03223456789',
    'address': 'Village Salah Khan',
    'quality': '78%',
  },
  {
    'name': 'Sanaullah Abbas',
    'phone': '03334567890',
    'address': 'Sobodera',
    'quality': '88%',
  },
  {
    'name': 'Imran Malik',
    'phone': '03455678901',
    'address': 'Goth nemat khan',
    'quality': '81%',
  },
  {
    'name': 'Ashar Siddiqui',
    'phone': '03566789012',
    'address': 'Goth Ghulam khan',
    'quality': '95%',
  },
  {
    'name': 'Usman Ghani',
    'phone': '03017890123',
    'address': 'Goth Shah ',
    'quality': '79%',
  },
  {
    'name': 'Khan Muhammad',
    'phone': '03128901234',
    'address': 'Goth Ali bhutto',
    'quality': '90%',
  },
];
