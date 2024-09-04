import 'package:flutter/material.dart';

class ManageBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Bookings'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 200, right: 200, top: 30, bottom: 100),
        child: ListView.builder(
          itemCount: 30,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Booking ${index + 1}'),
                subtitle: Text('Date: 2022-01-01'),
                trailing: Icon(Icons.delete),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
