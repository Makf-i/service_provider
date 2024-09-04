import 'package:flutter/material.dart';

class ManagePricing extends StatelessWidget {
  const ManagePricing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Manage Pricing',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Divider(height: 1),
        Text(
          'Add a new pricing plan',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigate to AddPricingPlanScreen
          },
          child: Text('Add Pricing Plan'),
        ),
        Divider(height: 1),
        Text(
          'View existing pricing plans',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
        ElevatedButton(
          child: Text("data"),
          onPressed: () {},
        )
      ],
    );
  }
}
