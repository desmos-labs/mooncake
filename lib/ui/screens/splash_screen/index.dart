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
          return HomeScreen();
        }

        return SafeArea(
          child: Container(
            decoration: ThemeDecorations.pattern(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('assets/images/logo.png'),
                  key: PostsKeys.loginScreenLogo,
                  width: 125,
                ),
                Text(
                  PostsLocalizations.of(context).translate(Messages.appName),
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
