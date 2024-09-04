import 'package:add_boat/models/boat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUser = FirebaseAuth.instance.currentUser!;

class BoatProvider extends StreamNotifier<List<BoatService>> {
  BoatProvider() : super();

  @override
  Stream<List<BoatService>> build() {
    return FirebaseFirestore.instance
        .collection('service providers')
        .doc(currentUser.uid)
        .collection('available boats')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BoatService.fromMap(doc.id, doc.data()))
              .toList(),
        )
        .handleError((error) {
      print('Error in stream: $error');
      return <BoatService>[]; // Return an empty list
    });
  }

  void removeAddedBoat(BoatService brc) {
    state.whenData(
      (value) {
        for (BoatService b in value) {
          if (b.id == brc.id) {
            FirebaseFirestore.instance
                .collection('service providers')
                .doc(currentUser.uid)
                .collection('available boats')
                .doc(brc.id)
                .delete()
                .then((value) {
              print('Document successfully deleted!');
            }).catchError((error) {
              print('Error deleting document: $error');
            });
          }
        }
      },
    );
  }
}

final avlbBoatsProviders =
    StreamNotifierProvider<BoatProvider, List<BoatService>>(
  () => BoatProvider(),
);
