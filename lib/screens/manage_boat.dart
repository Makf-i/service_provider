import 'dart:typed_data';

import 'package:add_boat/data/amenities.dart';
import 'package:add_boat/data/meal_addons.dart';
import 'package:add_boat/data/safety.dart';
import 'package:add_boat/models/addon_model.dart';
import 'package:add_boat/models/boat_service.dart';
import 'package:add_boat/providers/boat_provider.dart';
import 'package:add_boat/widgets/checkbox.dart';
import 'package:add_boat/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();
final currentUser = FirebaseAuth.instance.currentUser!;

class ManageBoatScreen extends ConsumerStatefulWidget {
  const ManageBoatScreen({super.key});

  @override
  ConsumerState<ManageBoatScreen> createState() => _ManageBoatScreenState();
}

class _ManageBoatScreenState extends ConsumerState<ManageBoatScreen> {
  var _eneteredName = '';
  var _eneteredCapacity = '';
  var _eneteredDescription = '';
  Uint8List? _selectedImageData; //when working with web
  final _form = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  bool _isFormResetted = false;

  //these will store the checkbox quantities
  final Map<String, bool> _selectedAmenities = {};
  final Map<String, bool> _selectedSafetyFeatures = {};
  final Map<String, bool> _selectedMeals = {};

  var _isUploading = false;
  bool _screenBoatList = true;

  void _sumbmit() async {
    final isValid = _form.currentState!.validate();
    _form.currentState!.save();
    if (!isValid && _selectedImageData == null) {
      //this will save the values inside TextFormField
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter the required data'),
        ),
      );
      return;
    }

    //if(_eneteredName)

    try {
      setState(() {
        _isUploading = true;
      });

      print("current user ${currentUser.email}");

      //uploading the image to Firestore
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('service providers')
          .child(currentUser.uid)
          .child('images')
          .child(_eneteredName)
          .child('$_eneteredName.jpg');
      await storageRef.putData(_selectedImageData!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('service providers')
          .doc(currentUser.uid)
          .collection('available boats')
          .doc()
          .set({
        'id': uid.v1(),
        'service_name': _eneteredName,
        'avlbSeats': _eneteredCapacity,
        'image': imageUrl,
        'description': _eneteredDescription,
        'rate': "",
        'amenities': _selectedAmenities,
        'safetyFeatures': _selectedSafetyFeatures,
        'meals': _selectedMeals,
      });
      
    } on Firebase catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed with error: $error"),
          ),
        );
      }
    }
    setState(() {
      _isUploading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Uploaded Successfully"),
        ),
      );
    }
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 1), curve: Curves.linear);
    _form.currentState!.reset();
    setState(() {
      _isFormResetted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final avlbBoats = ref.watch(avlbBoatsProviders);
    final avlbBoatsNotifier = ref.read(avlbBoatsProviders.notifier);

    Widget boatList = avlbBoats.when(
      data: (data) {
        if (data.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(
                left: 200, right: 200, top: 30, bottom: 100),
            child: Column(
              children: [
                for (BoatService brc in data)
                  Card(
                    child: ListTile(
                      title: Text(brc.serviceName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          avlbBoatsNotifier.removeAddedBoat(brc);
                        },
                        tooltip: "Remove this boat",
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        return const Center(
          child: Text("No Boats added yet"),
        );
      },
      error: (error, stackTrace) {
        return Text(
          'Error: $error\n$stackTrace',
        );
      },
      loading: () {
        return const Center(
          heightFactor: 500,
          child: CircularProgressIndicator(),
        );
      },
    );

    Widget addBoat = Padding(
      padding:
          const EdgeInsets.only(left: 200, right: 200, top: 20, bottom: 100),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Boat',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, color: Colors.red)),
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null) {
                  return 'Name is required';
                }
                return null;
              },
              onSaved: (value) {
                _eneteredName = value!;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Capacity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null) {
                  return 'Capacity is required';
                }
                return null;
              },
              onSaved: (value) {
                _eneteredCapacity = value!;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Text(
              'Add a small description ',
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              // validator: (value) {
              //   check for validation
              // },
              onSaved: (value) {
                _eneteredDescription = value!;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Photo',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Text("Upload photos of your boat"),
            const SizedBox(height: 10),
            UserImagePicker(
              onPickedImage: (pickedImage) => _selectedImageData = pickedImage,
              clear: _isFormResetted,
            ),
            const SizedBox(height: 20),
            const Text(
              'Amenities',
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w600),
            ),
            const Text(
                "Select the amenities available on your boat to enhance passenger comfort and experience."),
            Column(
              children: [
                for (AddOnsModel adn in amenitiesList)
                  CheckboxTile(
                      text: adn.name,
                      val: _selectedAmenities[adn.name] ?? false,
                      clear: _isFormResetted,
                      onClicked: (val) {
                        setState(() {
                          _selectedAmenities[adn.name] = val ?? false;
                        });
                      })
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Safety features',
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w600),
            ),
            const Text(
                "Select the safety features available on your boat to enhance passenger Safety."),
            Column(
              children: [
                for (AddOnsModel adn in safetyList)
                  CheckboxTile(
                    text: adn.name,
                    clear: _isFormResetted,
                    val: _selectedSafetyFeatures[adn.name] ?? false,
                    onClicked: (val) {
                      setState(() {
                        _selectedSafetyFeatures[adn.name] = val ?? false;
                      });
                    },
                  )
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Meals',
              style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.w600),
            ),
            const Text("Select the available meals on your boat."),
            Column(
              children: [
                for (AddOnsModel adn in mealAddOnsList)
                  CheckboxTile(
                    text: adn.name,
                    clear: _isFormResetted,
                    val: _selectedMeals[adn.name] ?? false,
                    onClicked: (val) {
                      setState(() {
                        _selectedMeals[adn.name] = val ?? false;
                      });
                    },
                  )
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue)),
                onPressed: _sumbmit,
                child: Text(
                  _isUploading ? 'Uploading data...' : "Save",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                  selected: _screenBoatList,
                  selectedTileColor: Colors.blue.shade200,
                  onTap: () {
                    setState(() {
                      _screenBoatList = true;
                    });
                  },
                  title: const Center(child: Text("Boat List"))),
            ),
            Expanded(
              child: ListTile(
                  selected: !_screenBoatList,
                  selectedTileColor: Colors.blue.shade200,
                  onTap: () {
                    setState(() {
                      _screenBoatList = false;
                    });
                  },
                  title: const Center(child: Text("Add new boat"))),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screenBoatList ? boatList : addBoat,
              transitionBuilder: (child, animation) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          ),
        ),
      ],
    );
  }
}
