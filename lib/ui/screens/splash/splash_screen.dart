import 'package:flutter_svg/svg.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Represents the screen that is shown to the user during the application
/// loading before having defined whether the user is authenticated or not.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoggedOut) {
          return LoginScreen();
        } else if (state is LoggedIn) {
          return _homeScreen();
        }

        return Container(
          padding: EdgeInsets.all(16.0),
          color: PostsTheme.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                'assets/images/logo.svg',
                width: 100,
                color: Colors.white,
              ),
              Text(
                PostsLocalizations.of(context).appTitle,
                style: PostsTheme.theme.textTheme.bodyText2.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                PostsLocalizations.of(context).splashLoadingData,
                style: PostsTheme.theme.textTheme.bodyText2.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _homeScreen() {
    return BlocProvider(
      create: (context) => HomeBloc.create(context),
      child: HomeScreen(),
    );
  }
}
