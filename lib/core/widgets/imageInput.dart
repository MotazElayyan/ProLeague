import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onImagePick});

  final void Function(File pickedImage) onImagePick;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImageFile;

  Future<void> _selectImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: source,
      maxHeight: 200,
      maxWidth: 200,
      imageQuality: 50,
    );

    if (pickedImage == null) return;

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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _selectImage(ImageSource.gallery),
              icon: Icon(
                Icons.photo,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: Text(
                'Gallery',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextButton.icon(
              onPressed: () => _selectImage(ImageSource.camera),
              icon: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: Text(
                'Camera',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
