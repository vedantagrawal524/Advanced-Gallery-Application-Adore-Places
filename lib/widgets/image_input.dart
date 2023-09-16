import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.ontakeImage});
  final void Function(File image) ontakeImage;
  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _takenImage;
  final _imagePicker = ImagePicker();
  void _takePicture() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _takenImage = File(pickedImage.path);
    });
    widget.ontakeImage(_takenImage!);
  }

  void _selectPicture() async {
    final selectedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 600);
    if (selectedImage == null) {
      return;
    }
    setState(() {
      _takenImage = File(selectedImage.path);
    });
    widget.ontakeImage(_takenImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Image Choosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_takenImage != null) {
      previewContent = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _takenImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _takePicture,
              icon: const Icon(Icons.camera),
              label: const Text('Capture Image'),
            ),
            TextButton.icon(
              onPressed: _selectPicture,
              icon: const Icon(Icons.image),
              label: const Text('Select from Gallery'),
            ),
          ],
        ),
      ],
    );
  }
}
