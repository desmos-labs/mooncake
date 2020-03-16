import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents the screen that is shown to the user during the application
/// loading before having defined whether the user is authenticated or not.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        // TODO: Handle the case where the user has logged out but he has biometrics or password
        if (state is LoggedOut) {
          return LoginScreen();
        } else if (state is LoggedIn) {
          return _homeScreen();
        }

        return Container(
          decoration: ThemeDecorations.pattern,
          child: Column(
            children: <Widget>[
              SizedBox(height: 175),
              Image(
                image: AssetImage('assets/images/login_logo.png'),
                key: PostsKeys.loginScreenLogo,
                width: 125,
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
