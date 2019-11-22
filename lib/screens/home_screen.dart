import 'package:desmosdemo/blocs/blocs.dart';
import 'package:desmosdemo/keys.dart';
import 'package:desmosdemo/localization.dart';
import 'package:desmosdemo/models/models.dart';
import 'package:desmosdemo/routes.dart';
import 'package:desmosdemo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// HomeScreen is the main screen of the application, and the one from which
/// the user can access the posts timeline as well as other screens by
/// using the navigation bar
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterBlocLocalizations.of(context).appTitle),
            actions: [],
          ),
          body: activeTab == AppTab.posts ? Posts() : Stats(),
          floatingActionButton: FloatingActionButton(
            key: PostsKeys.addPost,
            onPressed: () {
              Navigator.pushNamed(context, PostsRoutes.addPost);
            },
            child: Icon(Icons.add),
            tooltip: FlutterBlocLocalizations.of(context).addPost,
          ),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabsBloc>(context).add(UpdateTab(tab)),
          ),
        );
      },
    );
  }
}
