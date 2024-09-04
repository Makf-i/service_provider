import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(
      {super.key, required this.onPickedImage, this.clear = false});

  final void Function(Uint8List pickedImage) onPickedImage;
  final bool clear;

  @override
  State<StatefulWidget> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  Uint8List? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 900,
        maxHeight: 500);

    if (pickedImage == null) {
      return;
    }

    final imageByte = await pickedImage.readAsBytes();

    setState(() {
      _pickedImageFile = imageByte;
    });
    widget.onPickedImage(_pickedImageFile!);
    print("got image");
  }

  @override
  Widget build(BuildContext context) {
    Widget hintForImage = const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          color: Colors.blue,
        ),
        Text(
          'Drag & drop files here, or click to select files',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        Text(
          "Supports JPG, PNG, and SVG files up to 1MB",
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );

    return GestureDetector(
      onTap: _pickImage,
      child: IntrinsicHeight(
        child: IntrinsicWidth(
          child: Container(
            width: 800,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
                child: _pickedImageFile != null
                    ? widget.clear
                        ? hintForImage
                        : Image.memory(_pickedImageFile!)
                    : hintForImage),
          ),
        ),
      ),
    );
  }
}
