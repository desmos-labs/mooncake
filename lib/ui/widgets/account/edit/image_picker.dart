import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mooncake/ui/localization/export.dart';

/// Represents the callback that will be called when the user chooses an image.
typedef OnImageChose = void Function(File image);

/// Shows a dialog asking the user where to select the image from.
void showImagePicker({
  @required BuildContext context,
  @required OnImageChose onImageChosen,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(PostsLocalizations.of(context).chooseImageSourceTitle),
        children: [
          _option(
            context,
            PostsLocalizations.of(context).chooseGalleryOption,
            ImageSource.gallery,
            onImageChosen,
          ),
          _option(
            context,
            PostsLocalizations.of(context).chooseCameraOption,
            ImageSource.camera,
            onImageChosen,
          ),
        ],
      );
    },
  );
}

/// Represents a single option inside the possible image sources choices.
Widget _option(
  BuildContext context,
  String text,
  ImageSource source,
  OnImageChose callback,
) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () async {
        // Close the dialog
        Navigator.pop(context);

        // Pick the image
        var image = await ImagePicker.pickImage(source: source);
        callback(image);
      },
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Text(text),
          ],
        ),
      ),
    ),
  );
}
