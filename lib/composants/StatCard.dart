import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String label;
  final int count;
  const StatCard({super.key, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 140,
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
