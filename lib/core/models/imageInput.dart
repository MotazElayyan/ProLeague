import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onImagePick});

  final void Function(File pickedImage) onImagePick;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImageFile;

  void _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 200,
      maxWidth: 200,
      imageQuality: 50,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImageFile = File(pickedImage.path);
    });

    widget.onImagePick(_selectedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 100,
          backgroundColor: Colors.grey,
          foregroundImage:
              _selectedImageFile != null
                  ? FileImage(_selectedImageFile!)
                  : null,
        ),
        TextButton.icon(
          onPressed: _selectImage,
          label: Text(
            'Add Image',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          icon: Icon(
            Icons.image,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
