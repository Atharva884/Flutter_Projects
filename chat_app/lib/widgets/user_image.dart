import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final _imagePicker = ImagePicker();

class UserImage extends StatefulWidget {
  const UserImage({super.key, required this.onPickedImage});
  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  File? _pickedImage;

  void captureFromGallery() async {
    final captureImageFromGalley = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: double.infinity,
    );

    if (captureImageFromGalley == null) {
      return;
    }

    setState(() {
      _pickedImage = File(captureImageFromGalley.path);
    });

    widget.onPickedImage(_pickedImage!);
  }

  void captureImage() async {
    final captureImage = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: double.infinity,
    );

    if (captureImage == null) {
      return;
    }

    setState(() {
      _pickedImage = File(captureImage.path);
    });

    widget.onPickedImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade600,
          radius: 48,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: captureImage,
              icon: const Icon(Icons.camera),
              label: Text(
                "Add Image",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            TextButton.icon(
              onPressed: captureFromGallery,
              icon: const Icon(Icons.image),
              label: Text(
                "Open Galley",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            )
          ],
        )
      ],
    );
  }
}
