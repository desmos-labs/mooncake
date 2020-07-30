import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/ui/screens/post_details_screen/widgets/export.dart';

/// Represents the screen that is shown to the user when he wants
/// to visualize the details of a specific [postId].
class PostDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(PostsLocalizations.of(context)
            .translate(Messages.postDetailsTitle)),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: SafeArea(
        child: Container(
          color: Theme.of(context).cardColor,
          child: BlocBuilder<PostDetailsBloc, PostDetailsState>(
            builder: (context, state) {
              if (state is LoadingPostDetails) {
                return PostDetailsLoading();
              }

              return PostDetailsMainContent();
            },
          ),
        ),
      ),
    );
  }
}
