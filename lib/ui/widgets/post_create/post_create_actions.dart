import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the bar containing the actions that can be taken from
/// the post editor.
class PostCreateActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostInputBloc, PostInputState>(
      builder: (context, state) {
        // ignore: close_sinks
        final bloc = BlocProvider.of<PostInputBloc>(context);
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    tooltip: state.allowsComments
                        ? PostsLocalizations.of(context).commentsEnabledTip
                        : PostsLocalizations.of(context).commentsDisabledTip,
                    icon: Icon(state.allowsComments
                        ? FontAwesomeIcons.solidComments
                        : FontAwesomeIcons.comments),
                    onPressed: () {
                      bloc.add(AllowsCommentsChanged(!state.allowsComments));
                    },
                  ),
                  IconButton(
                    tooltip: PostsLocalizations.of(context).cameraTip,
                    icon: Icon(FontAwesomeIcons.camera),
                    onPressed: () => _pickImage(bloc, ImageSource.camera),
                  ),
                  IconButton(
                    tooltip: PostsLocalizations.of(context).galleryTip,
                    icon: Icon(FontAwesomeIcons.solidImage),
                    onPressed: () => _pickImage(bloc, ImageSource.gallery),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(PostInputBloc bloc, ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      bloc.add(ImageAdded(image));
    }
  }
}
