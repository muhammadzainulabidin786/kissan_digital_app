import 'dart:math';
import 'package:flutter/material.dart';

class GraphScreen extends StatelessWidget {
  GraphScreen({super.key}) {
    final random = Random();
    _generateDistrictData(random);
  }

  final Map<String, double> districtQuality = {};
  final List<Color> districtColors = [];

  void _generateDistrictData(Random random) {
    for (String district in sindhDistricts) {
      districtQuality[district] = (60 + random.nextInt(31)).toDouble();
    }

    final sortedEntries =
        districtQuality.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    districtQuality
      ..clear()
      ..addEntries(sortedEntries);

    for (int i = 0; i < sindhDistricts.length; i++) {
      districtColors.add(
        HSVColor.fromAHSV(
          1,
          i * (360 / sindhDistricts.length),
          0.8,
          0.8,
        ).toColor(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'District-wise Cotton Quality Analysis',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildHorizontalBarChart(),
        ],
      ),
    );
  }

  Widget _buildHorizontalBarChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _chartDecoration(),
      child: Column(
        children: [
          const Text(
            'Quality Percentage by District',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: districtQuality.length,
              itemBuilder: (context, index) {
                final district = districtQuality.keys.elementAt(index);
                return _BarChartItem(
                  label: district,
                  value: districtQuality.values.elementAt(index),
                  color: districtColors[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _chartDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

class _BarChartItem extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _BarChartItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LayoutBuilder(
              builder:
                  (context, constraints) => Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    width: constraints.maxWidth * (value / 90),
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${value.round()}%',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

final List<String> sindhDistricts = [
  'Badin',
  'Dadu',
  'Ghotki',
  'Hyderabad',
  'Jacobabad',
  'Jamshoro',
  'Karachi Central',
  'Kashmore',
  'Khairpur',
  'Larkana',
  'Matiari',
  'Mirpur Khas',
  'Nawabshah',
  'Naushahro Feroze',
  'Qambar Shahdadkot',
  'Sanghar',
  'Shaheed Benazirabad',
  'Shikarpur',
  'Sukkur',
  'Sujawal',
  'Tando Adam',
  'Tando Allahyar',
  'Tando Muhammad Khan',
  'Thatta',
  'Tharparkar',
  'Umerkot',
  'Keamari',
  'Karachi East',
  'Karachi West',
];
